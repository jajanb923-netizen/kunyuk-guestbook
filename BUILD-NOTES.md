# Build notes — Kunyuk Guestbook (Agent ID Hackathon)

Built 2026-11-21 (coordinator session dbbad140). **BUILD ONLY: nothing deployed,
nothing spent, nothing submitted, no private key used or stored anywhere.**

## Contract design

`src/KunyukGuestbook.sol` — Solidity 0.8.24, zero dependencies, single file
(so BscScan verification is a plain single-file verify).

- `sign(string message)`: requires `AGENT_ID.balanceOf(msg.sender) > 0`
  (Agent ID contract `0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F`, SPACE ID
  Agent ID ERC-721, non-transferable). Message must be 1–280 bytes.
  One signature per address (`hasSigned` mapping). Emits `Signed`.
- Views: `totalSignatures()`, `getSignature(uint256)`, `hasSigned(address)`.
- **No owner/admin functions, no fees, no token, no upgradeability, no
  pausing.** The contract cannot hold or move funds. There is nothing to
  disclose under "owner permissions" beyond: anyone holding an Agent ID may
  call `sign()` once.
- One-per-address is deliberate: the hackathon ranks on the **number of
  interacting Agent ID addresses**, so distinct signers are the metric, and
  it also stops one address spamming the guestbook.
- No name-to-wallet lookup anywhere (contract or frontend) — that use of
  Agent ID is explicitly banned by the rules.

Note: the announcement prints the Agent ID address in lowercase
(`0x60b926...`); Solidity requires the EIP-55 checksummed form
`0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F`. Same address, different case.

## Tests — 10/10 pass

`forge test` (Foundry 1.9.0, solc 0.8.24, optimizer on, 200 runs):

| Test | Result |
| --- | --- |
| holderCanSign | PASS |
| nonHolderCannotSign | PASS (reverts "caller does not hold an Agent ID") |
| emptyMessageReverts | PASS |
| messageTooLongReverts (281 bytes) | PASS |
| messageExactly280Accepted | PASS |
| oneSignaturePerAddress | PASS (second sign reverts "already signed") |
| signedEventEmitted | PASS |
| multipleSignersAndViews | PASS |
| getSignatureOutOfBoundsReverts | PASS |
| noOwnerOrAdminFunctions | PASS (calls to `owner()` / `pause()` revert — no fallback) |

Test technique: the mock Agent ID's runtime bytecode is placed at the real
Agent ID address with `vm.etch`, so the production code path (hard-coded
address) is exercised exactly as deployed.

## Gas — measured, not estimated from tables

- **Deploy (contract creation): 919,112 gas**
  Measured with `cast estimate --create` against live BSC mainnet state,
  from the user's own address. Cross-check: `forge script` dry-run on the
  BSC fork reported 1,183,932 total gas for the whole script (deploy + two
  view calls + script overhead) at 0.05 gwei max fee.
- **sign(): ~151,953 gas first signer (cold storage), ~127,814 gas later
  signers** — measured on local EVM with `gasleft()`; mainnet will be very
  close (same code path, storage starts empty in both cases).

### BNB cost

| Gas price | Deploy (919,112 gas) | One signature (~152k gas) |
| --- | --- | --- |
| 0.05 gwei | 0.0000460 BNB | ~0.0000076 BNB |
| **0.1 gwei** | **0.0000919 BNB** | ~0.0000152 BNB |
| 1 gwei | 0.0009191 BNB | ~0.0001520 BNB |

### Does the deploy fit the wallet?

Deployer wallet balance verified live 2026-11-21: **~0.00012 BNB**.

- **At ≤0.13 gwei the deploy FITS** (0.0000919 BNB at 0.1 gwei, leaving
  ~0.000028 BNB). BSC gas price is usually in this range, and the dry-run
  simulation estimated a 0.05 gwei max fee.
- **At 1 gwei it does NOT fit** — short by ~0.0008 BNB.
- Honest assessment: the deploy fits today at normal BSC gas prices, but
  with almost no margin — one failed attempt or a gas spike would block it,
  and the deployer wallet would be left nearly empty afterwards. A small
  top-up (e.g. 0.001 BNB) before deploying would remove the risk entirely.
  That top-up is the user's decision; nothing has been spent.

## Frontend — verified, not just eyeballed

`index.html` — single static page, zero dependencies, no backend, no tracking.
Connects only via `window.ethereum` (injected provider, as in the Binance
App's in-app browser). Reads via public BSC RPC
(`https://bsc-rpc.publicnode.com`). Hand-rolled minimal ABI encode/decode,
verified against `cast`:

- `sign(string)` calldata == `cast calldata` output — MATCH
- `getSignature(uint256)` calldata == `cast calldata` output — MATCH
- `hasSigned(address)` calldata == `cast calldata` output — MATCH
- Decoding a `cast abi-encode`d `(address,string,uint256)` return tuple
  reproduces signer, message, and timestamp exactly — MATCH
- Unicode message round-trip works; 280-char encoding length correct.

One real bug was caught by this testing (string-tail offset was treated as a
character offset instead of a byte offset) and fixed in `decodeString`.

The page is fully functional except for one placeholder: `CONTRACT_ADDRESS`
at the top of the script is `0x0000…0000` until the contract is deployed.
Until then the page shows "contract not deployed yet".

## Official submission route — PARTIAL BLOCKER (see SUBMISSION.md)

- Announcement read in full: submission 18 Nov – 9 Dec 2026 08:00 UTC
  (= 9 Dec 15:00 WIB); no registration needed; submit project name, website,
  contract address(es), Agent ID usage description + other materials.
- The announcement and its Binance Square mirror both show a **"Submit
  Project Now"** button, but its target URL is **not exposed in any text
  crawl** (VM direct fetch of binance.com returns empty; the href is rendered
  by JavaScript). The X-promotion survey
  (`app.binance.com/uni-qr/user-survey/ff6832f8d2984af289068c9450a3c98c`)
  was verified to be the *community* form, NOT the project submission.
- **Needed from the parent (live browser):** open the Square post, click
  "Submit Project Now", record the survey URL + exact fields in
  SUBMISSION.md. Do not guess the URL.

## Still needed before deploy

1. **Gas decision:** deploy at ≤0.13 gwei fits the ~0.00012 BNB balance;
   a small top-up (~0.001 BNB) is recommended for margin — user's call.
2. **Deploy approval:** deploy only after a fresh gas preview + the user's
   explicit yes in chat (per On-Chain Safety Rails). The deployer key must
   come from the user's own wallet flow (Binance App / `baw`); no key is
   stored in this work dir.
3. **GitHub repo** (parent creates via signed-in browser):
   `jajanb923-netizen/kunyuk-guestbook`, public, MIT. Then publish
   `index.html` via GitHub Pages and set `CONTRACT_ADDRESS` in it.
   `lib/forge-std` is vendored in the work dir; if the push excludes it,
   tests need `forge install foundry-rs/forge-std` first.
4. **BscScan verification** of the deployed contract source (single file,
   MIT, solc 0.8.24, optimizer on, 200 runs).
5. **Recruit 30 Agent ID holders** (RECRUIT.md) — Innovation Award
   eligibility threshold; keep signing open until 9 Dec.
6. **Submit** via the "Submit Project Now" survey once its URL is captured
   (see SUBMISSION.md checklist). Reward address to be confirmed with
   Hendrik at submission time — not filled in here.
7. The `broadcast/` and `cache/` folders in this work dir contain only the
   dry-run simulation output (no real transaction). Safe to delete before
   pushing; `out/` is build output.
