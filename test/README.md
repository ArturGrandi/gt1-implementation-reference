# GT 1.0 — Tests & Verification

This directory contains the test suite for the GT 1.0 controlled reference implementation.

Status: Binding (verification scope)

The goal of tests is to verify correctness against:
- spec/verification_checklist.md (acceptance gate),
- spec/verification_matrix.md (requirements × modules × methods),
- spec/security.md (stress cases),
- spec/operations.md (rails & routing),
- spec/architecture.md (module boundaries).

Passing tests is not sufficient if invariants are violated.

---

## Canonical directory convention

This repository uses `test/` as the canonical test directory (Foundry / Solidity convention).

Any documentation that mentions `tests/` MUST be interpreted as referring to `test/`.

---

## Required test categories

### 1) Unit tests — `test/unit/`
Purpose:
- verify deterministic logic of isolated functions/modules.
Examples:
- fund accounting moves,
- revert conditions for gates,
- view functions and event emission correctness.

### 2) Invariant tests — `test/invariant/`
Purpose:
- continuously assert invariants never break under sequences of actions.
Must cover at minimum:
- CR/SR invariants,
- stability standard,
- mint-gates,
- “no forced conversion / no liquidation” invariant.

### 3) Fuzz tests — `test/fuzz/`
Purpose:
- property-based testing for edge cases and adversarial inputs.
Must cover at minimum:
- oracle invalid/stale/inconsistent inputs,
- ETH rail refund correctness,
- System Fund coverage gate (P_next_min preservation),
- stablecoin suspension containment.

### 4) Simulation tests — `test/sim/`
Purpose:
- higher-level scenario simulations (multi-step flows).
Must cover at minimum:
- oracle failure → pause → mint redirection → recovery,
- GasReserve depletion → ETH rail enable/disable behavior,
- asset suspension sequences without price logic changes.

---

## Non-goals

- No production security guarantees.
- No MEV-proofing claims.
- No economic redesign proposals.

---

## Acceptance rule

A build is acceptable only if it satisfies:
- spec/verification_checklist.md (PASS), and
- the coverage described in spec/verification_matrix.md is implemented.

Any deviation requires a spec patch with explicit project owner approval.
