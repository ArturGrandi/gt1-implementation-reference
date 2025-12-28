# GT 1.0 — Genesis Specification (Canonical)

Status: Binding (Spec-first, canonical genesis record)

This document is the sole canonical source of GT 1.0 protocol initialization parameters,
virtual prehistory rules, genesis allocations, and deployment-time constants.

No genesis numbers or constants are to be duplicated in README, contribution docs,
or contract code. Other documents may reference this file, but must not restate values.

---

## 1) Canonical Placement Rule (Binding)

All protocol start conditions, including:
- virtual prehistory,
- initial supply allocation,
- DAO balances and human pools,
- deployment parameters (including baseline population and initial price),
- bootstrap wallet minimum,
- gas autonomy thresholds,

MUST be defined exclusively in this `spec/genesis.md` file.

---

## 2) Genesis Time Model

- Protocol launch time is **T0** (deployment timestamp, UTC).
- A virtual prehistory of **3333 days** is applied at genesis.
- Daily mint is fixed at **M = 10,000,000 GUCT/day**.

The 3333-day prehistory is virtual accounting only and does not imply prior protocol operation.

---

## 3) Genesis Supply Allocation (Virtual Pre-mint)

Total virtual pre-minted supply: **33,330,000,000 GUCT**.

### 3.1 DAO Fund (Treasury)
DAO Fund: **3,333,000,000 GUCT**, of which:
- **1,500,000,000 GUCT** are reserved for ambassadors and are claim-only after verification and manual multisig approval.
- **333,333,333 GUCT** are earmarked as DAO development reserve.
- The remaining DAO balance is treated as active DAO treasury.

### 3.2 Unverified Human Pool
Unverified Human Pool: **29,997,000,000 GUCT**, held as a single aggregated asset (Vault/Time Safe), not in circulation.

---

## 4) Verification at Launch

- Verified humans at genesis = **0**.
- Human verification and claims begin only after protocol launch.

---

## 5) Population Baseline (Runtime Parameter)

Replace any fixed population number with **N0**, where **N0** equals the official global human population at the moment of system launch.

- **N0 is a deployment parameter**, not a hardcoded constant.
- Verification remains open-ended.
- Any verified accounts exceeding **N0** are treated as newborn population and accrue value with coefficient **1 : 1.5** from the moment of verification.

---

## 6) Initial Price (Deployment Parameter)

Initial internal price at launch is fixed as:

**P0 = 0.00000001 USD per GUCT**

**P0 is a deployment parameter** and must be used consistently in all calculations.

---

## 7) Genesis Funding / Bootstrap (Grant / Donation Wallet)

Protocol bootstrap is executed via a Grant / Donation Wallet.

- Initial activation requires a minimum inflow of **≥ 1,000 USD-equivalent** in supported assets.
- The protocol does not control, limit, or guarantee the amount or timing of donations beyond this minimum.
- Funds sent to the Grant Wallet do not grant any right to GUCT and are treated as system inflows only.

---

## 8) Gas Autonomy (Binding)

The protocol does NOT subsidize user (“social”) transactions. Users pay their own gas.

Deposit/redeem protocol fees remain **0%** (gas only). No fee model changes are permitted.

### 8.1 GasReserve parameters (ops infrastructure only)
Define GasReserve (ETH/WETH) as protocol ops infrastructure only.

Thresholds are fixed:
- **minGas = 0.2 ETH**
- **targetGas = 1.1 ETH**

If GasReserve < minGas, the minimum is replenished manually by admin (external ETH transfer).

### 8.2 ETH rail routing & refund (v1, binding)
When the ETH Time Capital purchase rail is used (see spec/operations.md):
- all ETH retained by the protocol is routed to GasReserve up to targetGas (defined above),
- any excess ETH (msg.value beyond reaching targetGas) MUST be refunded in the same transaction,
- delivered GUCT MUST be computed only from the ETH retained (refunded ETH buys 0 GUCT).
---

## 9) Invariants Unaffected

These directives do not modify:
- fund mechanics,
- CR / SR invariants,
- 333-day stability standard,
- mint-gate rules,
- bonding logic (including premium caps),
- Time Capital logic,
- multi-asset liquidity design.
