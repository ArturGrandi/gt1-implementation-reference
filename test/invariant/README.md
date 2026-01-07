# Invariant Tests — GT 1.0

Scope: Binding (must never break)

This directory contains invariant tests.
These tests define properties that MUST hold across all execution paths.

If any invariant test fails, the implementation is INVALID.

---

## Mandatory invariants

### 1) CR / SR invariants
- no action path may violate CR or SR constraints.

### 2) 333-day stability standard
- stability windows must not be bypassable,
- no shortcut via oracle noise or asset suspension.

### 3) P_next_min preservation
- no action may reduce System Fund below required level,
- ETH TC purchases must preserve P_next_min.

### 4) Non-reflexive behavior
- oracle changes MUST NOT trigger cascade price or mint changes.

---

## References (binding)
- spec/verification_checklist.md
- spec/verification_matrix.md
- spec/security.md
- spec/architecture.md
