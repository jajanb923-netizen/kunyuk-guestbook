# Submission — Agent ID Hackathon

## Official submission route (as found 2026-11-21)

**Source:** Binance official announcement
https://www.binance.com/en/support/announcement/detail/95f5dbe0ea674a48a739b59e046648bf
(mirrored on Binance Square: https://www.binance.com/en/square/post/389517345917641)

**What the announcement says (step 3 of "How to Participate"):**

> "Submit your project name, website, contract address(es), Agent ID usage
> description, and other required materials during the Submission Period. No
> registration needed."

**Exact form URL — RESOLVED 2026-11-21 09:49 WIB (parent, live browser):** https://www.binance.com/en/survey/fb26d2bd25e04329b1ba77c7b3811d23 — captured by opening the official announcement and clicking the yellow **"Submit Project Now"** button. Page title: "Agent ID Hackathon Project Submission Form". It confirms: product must be live + min 30 Agent ID addresses interacted with the contract during the Submission Period; correct contract address required; deadline 9 Dec 2026 08:00:00 UTC. This survey ID (fb26d2bd25e04329b1ba77c7b3811d23) is DIFFERENT from the X-promotion survey (ff6832f8...), so it is the project form.

**Note:** the form page itself sits behind a Binance login wall ("Please log into your Binance account to begin the survey") — field labels inside the form could not be read without signing in. The fields in the pre-filled draft below come from the announcement; confirm exact labels when filling it in after login. Contract is now DEPLOYED (see below); BscScan source verification is in progress via the web form (CLI verify blocked: no API key).

**Deadline:** 9 Dec 2026 08:00 UTC (= 9 Dec 2026 15:00 WIB). Internal Review
9–17 Dec; Public Review 17–20 Dec; rewards within 14 business days after the
public announcement period, to the reward address given at submission.

## Pre-filled draft (paste into the form once the route is confirmed)

| Field | Value |
| --- | --- |
| Project name | Kunyuk Guestbook |
| Website | https://jajanb923-netizen.github.io/kunyuk-guestbook/ |
| Contract address(es) | **0x2328116640bdfb6772418332672820adb9774f7c** (BNB Chain mainnet, chain 56) — deployed 2026-11-21 18:14 WIB, tx 0xac93d8d958d85bb00d82ead0b46d923d04f5f512784c7a59058df5e4d8f71fde, block 134877340, gas 507,507 at 0.05 gwei (~0.0000254 BNB) |
| Contract source | Verified on BscScan (in progress via web form) + open-source in this repo (MIT) |
| Agent ID usage description | The guestbook only lets Agent ID (.ai) holders sign. The contract calls balanceOf(address) on the SPACE ID Agent ID contract (0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F) and requires the result to be greater than 0 before accepting a message. One signature per address, max 280 characters, stored on-chain with signer + timestamp. Agent ID is the product's core gating mechanism, not an add-on. |
| Reward receiving address | The user's payout wallet — confirm with Hendrik at submission time (do NOT invent it here). Use a USDC-receiving address on BNB Chain. |
| Team | Solo — Hendrik (Indonesia), Agent ID kunyuk95.ai |
| GitHub repo | https://github.com/jajanb923-netizen/kunyuk-guestbook (created 21 Nov 2026, public, MIT; code pushed 18:02 WIB, commit 53ae03f; GitHub Pages live at the website URL above; index.html updated with the deployed contract address — push pending) |

## Deploy record (2026-11-21 18:14 WIB)

- Deployer: throwaway 0xd39e914b81FBC1d4E1C348d37bC97db97498b7e3 (key in work-dir `.secrets/`, gitignored, never pushed). Funded 0.00008 BNB from the user's agentic wallet 0x9CF1ee7fF17B375F1abFb4ef0db2a283dd5d54de, funding tx 0x9ac8bfde06604b33d6badda5e70e031c927d5e6fc582daef49cad996f168aa27 (confirmed, block 134877220). Funding was needed because `baw contract-call` cannot deploy contracts (requires `--to`); the user approved the throwaway-deployer route in chat.
- Actual deploy gas 507,507 (the 919,112 pre-deploy estimate included script overhead). Leftover in deployer after deploy: ~0.0000546 BNB (recoverable to the agent wallet later).
- Wallet re-login done 18:05 WIB (pairing code, QR in Binance app) + Developer Mode ON until 28 Nov 2026 18:07 WIB.

## Checklist before submitting

- [x] Contract deployed on BNB Chain mainnet
- [ ] Contract source verified on BscScan
- [x] `CONTRACT_ADDRESS` set in `index.html` and page live on GitHub Pages
- [x] "Submit Project Now" survey URL recorded above (fb26d2bd25e04329b1ba77c7b3811d23); exact field labels to confirm after Binance login
- [ ] At least a few real Agent ID holders have signed (30 is the Innovation
      Award eligibility threshold; keep recruiting until 9 Dec)
- [ ] Reward receiving address confirmed with Hendrik
