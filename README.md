# Kunyuk Guestbook

A minimal guestbook on BNB Chain where **only Agent ID (`.ai`) holders can sign**.
Built for the Binance Agent ID Hackathon (Submission Period 18 Nov – 9 Dec 2026, 08:00 UTC).

- **Website (planned):** https://jajanb923-netizen.github.io/kunyuk-guestbook/
- **Contract address:** _TBD — set after deploy_ (see `SUBMISSION.md`)
- **Source code:** this repo, MIT licensed
- **Live demo / frontend:** `index.html` (single static page, no backend)

## What it is

Anyone who holds an Agent ID — the SPACE ID Agent ID ERC-721 (non-transferable)
on BNB Chain, contract `0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F` — can leave
one short public message (max 280 characters) in the guestbook. Each message
is stored on-chain with the signer's address and a timestamp, and anyone can
read all signatures without a wallet.

## How Agent ID is used

The contract checks holding exactly the way the official hackathon announcement
documents it: it calls `balanceOf(address)` on the Agent ID contract and only
lets you sign when the result is greater than 0. Agent ID is the core of the
product — without it, there is no guestbook. There is no other gating, no
allowlist, and no off-chain check.

## Owner permissions: NONE

There are **no admin functions at all** — no owner, no pause, no upgrade, no
fee changes, no freezing, no withdrawals. The contract holds no funds and
charges no fee; signers pay only the BNB network gas for their own transaction
(roughly 0.000013–0.00015 BNB depending on gas price). The full permission
surface is: anyone holding an Agent ID may call `sign()` once; anyone may call
the view functions.

## What it is not

- No token, no minting, no trading — this is not a trading product.
- No name-to-wallet lookup: the contract and the page never resolve an `.ai`
  name to an address, and never offer such a lookup.
- No promises of returns of any kind.
- No seed phrases, private keys, API secrets, or pairing codes are ever
  collected. The page connects only through your wallet's injected provider
  (`window.ethereum`), as in the Binance App's in-app browser. No QR codes,
  no WalletConnect, no third-party pairing, no server, no sessions, no tracking.

## Contract

`src/KunyukGuestbook.sol` (Solidity 0.8.24, no dependencies):

| Function | What it does |
| --- | --- |
| `sign(string message)` | Stores one message per Agent ID holder; reverts for non-holders, empty messages, messages over 280 bytes, and second signatures. Emits `Signed`. |
| `totalSignatures()` | Number of signatures so far. |
| `getSignature(uint256 i)` | One signature: `(signer, message, timestamp)`. |
| `hasSigned(address)` | Whether an address has already signed. |

Deploy gas (measured, see `BUILD-NOTES.md`): **919,112 gas** for contract
creation. At 0.1 gwei that is ~0.0000919 BNB; at 1 gwei ~0.0009191 BNB.

## Run the tests

```shell
forge test
```

10 tests, all passing: non-holders cannot sign, holders can, empty / over-long
messages revert, one signature per address, the `Signed` event is emitted,
view functions return the right data, and no owner/admin entry point exists.

## Deploy (dry-run first)

```shell
# Simulate only — prints the exact gas, sends nothing:
forge script script/Deploy.s.sol --rpc-url https://bsc-rpc.publicnode.com --private-key <KEY>

# Broadcast (only after a gas preview AND the deployer's explicit approval):
forge script script/Deploy.s.sol --rpc-url https://bsc-rpc.publicnode.com --broadcast --private-key <KEY>
```

After deploy, verify the source on BscScan and set `CONTRACT_ADDRESS` at the
top of `index.html` to the deployed address before publishing the page.

## Run the frontend

No build step. Serve `index.html` over HTTP(S) — e.g. GitHub Pages — and open
it in a wallet browser (Binance App in-app browser works). Reads use a public
BSC RPC; writes go through the injected provider only.

## Files

- `src/KunyukGuestbook.sol` — the contract
- `test/KunyukGuestbook.t.sol` — Foundry tests (mock Agent ID via `vm.etch`)
- `script/Deploy.s.sol` — deploy script (dry-run by default)
- `index.html` — the whole frontend, dependency-free vanilla JS
- `RECRUIT.md` — invitation drafts for Agent ID holders (English + Indonesian)
- `SUBMISSION.md` — official submission route + pre-filled draft
- `BUILD-NOTES.md` — design choices, gas numbers, remaining steps

## License

MIT — see `LICENSE`.
