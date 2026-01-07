# Unit Tests — GT 1.0

Scope: Binding (functional correctness)

This directory contains deterministic unit tests for GT 1.0.
Tests here validate explicit behaviors, revert conditions, and event correctness.

Unit tests MUST NOT:
- simulate long time progression,
- test probabilistic properties,
- encode economic redesign logic.

---

## What must be covered here

### 1) Oracle gating (functional)
- pause on stale / invalid / inconsistent oracle,
- resume on oracle recovery,
- no price mutation on oracle failure.

### 2) ETH rail functional gates
- enable only when GasReserve < targetGas,
- revert when GasReserve >= targetGas,
- correct retained ETH vs refunded ETH,
- correct GUCT amount derived from retained ETH only.

### 3) System Fund coverage transfer
- immediate transfer of q * P (USD accounting) from System Fund to Liquidity Fund,
- revert if P_next_min preservation fails.

### 4) Access control & permissions
- AI interfaces are read-only (no tx, no signing),
- inheritance executes only with explicit opt-in,
- inactivity < 222 days MUST NOT trigger transfer.

---

## References (binding)
- spec/verification_checklist.md
- spec/verification_matrix.md
- spec/security.md
- spec/operations.md
