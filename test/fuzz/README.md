# Fuzz Tests — GT 1.0

Scope: Binding (edge & adversarial behavior)

This directory contains fuzz / property-based tests.
The goal is to break assumptions under unexpected input sequences.

---

## Mandatory fuzz targets

### 1) Oracle fuzzing
- random oracle delays,
- inconsistent price feeds,
- extreme values (zero, max, NaN equivalent).

Expected result:
- pause issuance,
- redirect mint,
- no price mutation.

### 2) ETH rail fuzzing
- random msg.value around targetGas,
- rounding edges,
- refund correctness.

### 3) Asset suspension fuzzing
- random asset suspension order,
- rapid suspend/resume cycles.

---

## Fail conditions
Any fuzz case that:
- breaks invariants,
- changes internal price incorrectly,
- bypasses safety gates,
MUST be treated as FAIL.

---

## References (binding)
- spec/verification_matrix.md
- spec/security.md
- spec/operations.md
