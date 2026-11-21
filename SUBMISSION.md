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

**Note:** the form page itself sits behind a Binance login wall ("Please log into your Binance account to begin the survey") — field labels inside the form could not be read without signing in. The fields in the pre-filled draft below come from the announcement; confirm exact labels when filling it in after login. Do NOT fill or submit before the contract is deployed and verified.

**Deadline:** 9 Dec 2026 08:00 UTC (= 9 Dec 2026 15:00 WIB). Internal Review
9–17 Dec; Public Review 17–20 Dec; rewards within 14 business days after the
public announcement period, to the reward address given at submission.

## Pre-filled draft (paste into the form once the route is confirmed)

| Field | Value |
| --- | --- |
| Project name | Kunyuk Guestbook |
| Website | https://jajanb923-netizen.github.io/kunyuk-guestbook/ |
| Contract address(es) | TBD — fill after deploy on BNB Chain mainnet (chain 56) |
| Contract source | Verified on BscScan + open-source in this repo (MIT) |
| Agent ID usage description | The guestbook only lets Agent ID (.ai) holders sign. The contract calls balanceOf(address) on the SPACE ID Agent ID contract (0x60B9262456dE011F7d15a54CdD8c48bAaa8B022F) and requires the result to be greater than 0 before accepting a message. One signature per address, max 280 characters, stored on-chain with signer + timestamp. Agent ID is the product's core gating mechanism, not an add-on. |
| Reward receiving address | The user's payout wallet — confirm with Hendrik at submission time (do NOT invent it here). Use a USDC-receiving address on BNB Chain. |
| Team | Solo — Hendrik (Indonesia), Agent ID kunyuk95.ai |
| GitHub repo | https://github.com/jajanb923-netizen/kunyuk-guestbook (created 21 Nov 2026, public, MIT; code push pending — first push approval expired, awaiting user re-approval) |

## Checklist before submitting

- [ ] Contract deployed on BNB Chain mainnet
- [ ] Contract source verified on BscScan
- [ ] `CONTRACT_ADDRESS` set in `index.html` and page live on GitHub Pages
- [x] "Submit Project Now" survey URL recorded above (fb26d2bd25e04329b1ba77c7b3811d23); exact field labels to confirm after Binance login
- [ ] At least a few real Agent ID holders have signed (30 is the Innovation
      Award eligibility threshold; keep recruiting until 9 Dec)
- [ ] Reward receiving address confirmed with Hendrik
