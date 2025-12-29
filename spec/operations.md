# GT 1.0 — Operations Specification (Gas Autonomy & ETH Rail)

Status: Binding (implementation scope)

This document defines operational rules for:
- protocol gas autonomy (no social transaction subsidy),
- GasReserve (ETH/WETH) as ops infrastructure,
- Time Capital purchase rail via ETH when GasReserve is below target,
- correctness constraints (enable/disable rules, refund behavior),
- fund coverage transfer rules that preserve P_next_min invariants.

Genesis parameters (including thresholds) are defined only in:
- spec/genesis.md (canonical).

This file MUST NOT duplicate genesis constants.
Canonical time domain is defined in: spec/time_domain.md (binding).

---

## 1) Scope & Constraints (Binding)
All operational timing (windows, delays, pauses) is evaluated in Grand Time units.

### 1.1 No social transaction subsidy
The protocol does NOT subsidize user (“social”) transactions. Users pay their own gas.

### 1.2 Protocol fees unchanged
Deposit/redeem protocol fees remain 0% (gas only).
No fee model changes are permitted by contributions.

---

## 2) GasReserve (Ops Infrastructure Only)

### 2.1 Definition
GasReserve (ETH/WETH) exists solely to maintain protocol operational continuity (admin / ops execution),
not as a value layer, not as liquidity coverage for price logic, and not as a user-facing pool.

### 2.2 Manual minimum replenishment
If GasReserve drops below the minimum threshold defined in spec/genesis.md,
the minimum is replenished manually by admin via external ETH transfer.

No automatic on-chain buying is required to reach the minimum threshold.

---

## 3) ETH Purchase Rail (Time Capital Only)

### 3.1 Function-level intent
Enable a Time Capital purchase rail that accepts ETH (or WETH) as payment for acquiring GUCT strictly
from Time Capital inventory, under a strict enable/disable policy.

Canonical name reference:
- buyFromTimeCapitalWithETH() (or equivalent in implementation)

### 3.2 Enable/disable policy (binding)
The ETH rail is enabled only when GasReserve is below the target threshold defined in spec/genesis.md.

- If GasReserve < target threshold: ETH rail MAY be enabled.
- If GasReserve >= target threshold: ETH rail MUST be disabled (revert).

This policy is intended to prevent ETH settlement from becoming a general-purpose payment path.

### 3.3 Valuation source (ETH/USD oracle)
ETH payments are valued in USD-equivalent using an ETH/USD oracle.

Bonding rules, 111-day constraints, and premium caps remain unchanged.
Only settlement asset differs (ETH vs stable).

### 3.4 Settlement neutrality (clarification)
Time Capital purchases are settlement-agnostic at the specification level:
stablecoin settlement may be used for general TC purchase flows,
while ETH settlement is permitted only under the strict GasReserve-driven enable/disable policy.

Any earlier assumptions that TC purchases are stable-only are non-binding and superseded by this operations specification.

---

## 4) Liquidity Coverage Preservation (P_next_min Safety Gate)

### 4.1 Hard constraint
Any ETH-based Time Capital purchase MUST NOT violate predicted next minimum price logic (P_next_min).

Therefore, upon ETH-based purchase of q GUCT, the protocol MUST immediately secure liquidity coverage by
moving USD-equivalent value from the System Fund into the Liquidity Fund:

ΔF_liq_USD = q * P

This liquidity funding is sourced from the System Fund (USD accounting), NOT from incoming ETH.

### 4.2 Revert condition (binding)
ETH purchase MUST revert unless the System Fund has sufficient excess after funding q * P to still satisfy
the required System Fund level for P_next_min:

F_sys_USD - (q * P) >= F_sys_req_USD(P_next_min)

This is a hard safety gate. No exceptions, no partial settlement.

---

## 5) ETH Routing & Refund Rule (v1)

### 5.1 Routing priority
All ETH paid for the purchase is routed to GasReserve up to the target threshold defined in spec/genesis.md.

### 5.2 Refund correctness
If msg.value exceeds the amount needed to reach the target threshold,
the protocol MUST refund the excess ETH to the sender in the same transaction.

### 5.3 Pricing basis for delivery
The amount of GUCT delivered to the buyer is computed ONLY from the ETH retained
(i.e., refunded ETH does not buy GUCT).

This rule is mandatory to prevent implicit overpayment / ambiguous settlement.

---

## 6) Observability & Controls (Implementation Notes)

Implementations SHOULD expose the following read-only views/events to enable verification:
- GasReserve current balance
- ETH rail status: enabled/disabled (derived from GasReserve vs target threshold)
- retained ETH amount and refunded ETH amount per purchase
- System Fund -> Liquidity Fund transfer amount (USD accounting) per purchase
- explicit revert reasons for:
  - rail disabled,
  - insufficient System Fund after coverage transfer,
  - oracle invalid/unavailable.

This section is non-normative (SHOULD), except where marked binding above.

---

## 7) Non-Goals

- No general ETH payment support for user flows.
- No auto-market ETH buying or speculation logic.
- No changes to protocol fees, bonding premiums, or stability invariants.

---

## 8) References (Binding Links)

- spec/genesis.md — canonical deployment parameters (only source of constants)
- spec/architecture.md — module boundaries and mandatory safety gates
- spec/security.md — binding invariants, pause/revert policy, acceptance stress cases
