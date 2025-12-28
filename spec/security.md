# GT 1.0 — Security Specification (Stress Cases & Invariants)

Status: Binding (implementation scope)

This document enumerates security invariants and mandatory stress cases
for the GT 1.0 controlled reference implementation.

Genesis parameters are defined only in:
- spec/genesis.md (canonical).

This file MUST NOT duplicate genesis constants.

---

## 1) Security Posture (Non-Production)

This repository is a controlled reference implementation for research, simulation, and verification only.
No production deployment is implied.

---

## 2) Global Invariants (Must Hold)

### Verification as access control (binding)
Verification does not modify accrual or mining rates.
All humans accrue daily GUCT at a uniform 1:1 rate.

Verification grants ownership and usage rights only:
- claimability from the aggregated vault/time-safe,
- holding and transferring,
- redeeming/using within protocol rules.

Unverified accrual remains recorded in the aggregated vault/time-safe
without direct ownership or usage rights until verification.

### 2.1 No reflexive sell-offs / liquidation triggers
No oracle failure, gas depletion event, or rail-disable condition may trigger:
- forced asset conversion,
- automatic sell-offs,
- liquidation logic,
- reflexive mint adjustments.

### 2.2 Meaning is not defined by interfaces
Token standards, payment rails (stable vs ETH), and contract interfaces MUST NOT redefine
economic meaning. The meaning is defined by spec documents.

### 2.3 No social transaction subsidy
The protocol does NOT subsidize user (“social”) transactions. Users pay their own gas.
GasReserve is ops infrastructure only.

### 2.4 P_next_min preservation
Any action that changes fund balances MUST preserve predicted next minimum price logic (P_next_min)
and associated required System Fund level.

---

## 3) Oracle Security Model (Binding)

### 3.1 Oracle role
Oracles provide reference valuation only.
They do not:
- define economic meaning,
- trigger automatic sell-offs,
- enforce liquidation logic.

### 3.2 Oracle failure handling (valuation issuance pause)
If oracle data is invalid/stale/inconsistent:
- valuation issuance is paused (no new valuation issuance that depends on oracle),
- mint is redirected to Time Capital per existing mint-gate logic,
- protocol reference price remains unchanged.

No oracle failure may trigger forced conversion or reflexive price collapse.

---

## 4) Gas Autonomy & GasReserve (Binding)

### 4.1 Manual minimum replenishment
If GasReserve drops below the minimum threshold (spec/genesis.md),
the minimum is replenished manually by admin via external ETH transfer.

No automatic ETH market purchase is required to reach the minimum.

### 4.2 Depletion does not change economic state
GasReserve depletion MUST NOT alter:
- CR/SR invariants,
- price logic,
- mint logic beyond explicitly defined pauses/redirections.

Only operational continuity is affected.

---

## 5) ETH Time Capital Purchase Rail (Binding)

### 5.1 Enable/disable condition
ETH rail MUST be enabled only when GasReserve is below target (spec/genesis.md).
If GasReserve >= target: ETH rail MUST revert.

### 5.2 Oracle dependency
ETH rail depends on ETH/USD oracle for USD-equivalent valuation.
If oracle is invalid/stale: ETH rail MUST revert (no partial settlement).

### 5.3 System Fund coverage gate (P_next_min safety gate)
Upon ETH-based purchase of q GUCT, the protocol MUST secure liquidity coverage from System Fund:

ΔF_liq_USD = q * P

This is funded by System Fund (USD accounting), NOT by incoming ETH.

ETH purchase MUST revert unless System Fund remains sufficient after the transfer:

F_sys_USD - (q * P) >= F_sys_req_USD(P_next_min)

This is a hard invariant.

### 5.4 ETH routing & refund correctness (v1)
- ETH retained is routed to GasReserve up to target threshold.
- Any excess ETH MUST be refunded in the same transaction.
- GUCT delivered MUST be computed ONLY from retained ETH (refunded ETH buys 0 GUCT).

---

## 6) Mandatory Stress Cases (Test Matrix)

Implementations MUST be testable against the following scenarios.

### 6.1 GasReserve depletion scenarios
1) GasReserve falls below min threshold → protocol does NOT auto-buy ETH.
2) Admin tops up GasReserve externally → normal ops resumes.
3) GasReserve depleted to near-zero → no forced conversions, no price logic change.

### 6.2 ETH rail toggle scenarios
4) GasReserve < target → ETH rail enabled.
5) GasReserve == target → ETH rail disabled (revert).
6) GasReserve > target → ETH rail disabled (revert).
7) ETH rail purchase brings GasReserve to target → rail is disabled on subsequent calls.

### 6.3 Refund correctness scenarios
8) msg.value exactly needed to reach target → retain all, refund 0.
9) msg.value exceeds needed to reach target → retain required, refund remainder in-tx.
10) Verify delivered GUCT uses retained ETH only (refund does not buy GUCT).

### 6.4 Oracle invalid scenarios
11) ETH/USD oracle stale/invalid → ETH rail reverts (no partial settlement).
12) Valuation oracle stale/invalid → valuation issuance pauses; mint redirected to Time Capital; price unchanged.

### 6.5 System Fund coverage gate scenarios
13) System Fund sufficient: after funding q*P it still satisfies F_sys_req(P_next_min) → purchase allowed.
14) System Fund insufficient by 1 unit: after funding q*P it drops below requirement → purchase MUST revert.
15) Verify ΔF_liq_USD recorded/observable for each ETH purchase.

### 6.6 Cross-cases (oracle + gas)
16) GasReserve below target but oracle invalid → ETH rail MUST revert.
17) Oracle valid but System Fund gate fails → ETH rail MUST revert.
18) Oracle failure event does not enable any emergency conversion logic.

---

## 7) Observability Requirements (Recommended)

Implementations SHOULD emit events or expose views for:
- rail enabled/disabled state,
- retained/refunded ETH amounts,
- System Fund -> Liquidity Fund transfer amount (USD accounting),
- explicit revert reasons for oracle invalid, rail disabled, fund gate fail.

---

## 8) References

- spec/genesis.md — canonical deployment parameters
- spec/operations.md — operational behavior for gas autonomy & ETH rail
- spec/architecture.md — module map and component boundaries
