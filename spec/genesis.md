# GT 1.0 — Genesis (Canonical)

## Status
**Active. Binding.**

This document is the **single canonical source** of all genesis conditions and constants for GT 1.0.

**Do not duplicate genesis numbers** in:
- README
- CONTRIBUTION_GUIDELINES
- contract code
- other docs

Other documents may only **reference** this file.

---

## 1) Time Model

### T0 (Launch)
Protocol launch time is **T0**, defined as the deployment timestamp (UTC).

### Virtual Prehistory (3333 days)
A virtual prehistory of **3333 days** is applied at genesis for accounting initialization only.

- This does **not** imply prior protocol operation.
- This does **not** imply any prior public access.
- It is a **virtual accounting offset** applied at T0.

### Daily Mint
Daily mint is fixed at:

- **M = 10,000,000 GUCT / day**

This value is invariant at the protocol level (subject only to mint-gate rules defined elsewhere).

---

## 2) Population Baseline (Runtime Parameter)

### N0
Replace any fixed population number with **N0**, where:

- **N0 = official global human population at the moment of system launch (T0)**

N0 is a **deployment/runtime parameter**, not a hardcoded constant.

### Verification rule for population exceeding N0
Verification remains open-ended. Any verified accounts exceeding N0 are treated as **newborn population** and accrue value with coefficient:

- **1 : 1.5** from the moment of verification

---

## 3) Genesis Supply Allocation (Virtual Pre-mint)

Total virtual pre-minted supply at genesis:

- **S0 = 33,330,000,000 GUCT**

This supply exists as a **virtual accounting initialization** and is allocated as follows.

### 3.1 DAO Fund (Treasury)
DAO Fund allocation:

- **DAO0 = 3,333,000,000 GUCT**

Sub-allocations inside DAO Fund:

1) **Ambassador Reserve (claim-only, post-verification + multisig approval)**
   - **A0 = 1,500,000,000 GUCT**
   - Claim-only after verification
   - Requires manual multisig approval
   - Not in circulation

2) **DAO Development Reserve**
   - **D0 = 333,333,333 GUCT**
   - Earmarked for controlled development and implementation work
   - Disbursement remains operational (multisig-controlled) and non-commercial in intent

3) **Active DAO Treasury**
   - Remaining DAO balance after A0 and D0 is treated as active DAO treasury.

### 3.2 Unverified Human Pool (Aggregated Vault / Time Safe)
Unverified Human Pool allocation:

- **H0 = 29,997,000,000 GUCT**

Properties:
- Held as **one aggregated asset** (Vault / Time Safe)
- **Not in circulation**
- No individual balances exist at genesis
- Individual claims begin only after verification post-T0

---

## 4) Verification at Launch
At genesis:

- **Verified humans = 0**

Human verification and claims begin **only after protocol launch (post-T0)**.

---

## 5) Initial Internal Price (Deployment Parameter)

Initial internal reference price at launch is fixed as:

- **P0 = 0.00000001 USD per GUCT**

P0 is a **deployment parameter** and must be applied consistently in all calculations that require an initial USD reference.

---

## 6) Bootstrap Funding (Grant / Donation Wallet)

Protocol bootstrap is executed via a **Grant / Donation Wallet**.

Activation requirement:
- Minimum inflow of **≥ 1,000 USD-equivalent** in supported assets.

Clarifications:
- The protocol does **not** control, limit, or guarantee the amount or timing of donations beyond this minimum.
- Funds sent to the Grant Wallet do **not** grant any right to GUCT.
- Donations are treated as **system inflows only**.

---

## 7) Invariants Unaffected
These genesis directives do **not** modify:

- fund mechanics,
- CR / SR invariants,
- the 333-day stability standard,
- mint-gate rules,
- bonding logic,
- multi-asset liquidity design.

No economic redesign is requested or implied by this document.
