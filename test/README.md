# GT 1.0 — Tests & Verification

This directory contains tests for the GT 1.0 controlled reference implementation.

## Purpose

Tests MUST verify correctness against:
- `spec/verification_checklist.md`,
- `spec/security.md`,
- `spec/operations.md`.

Passing tests is not sufficient if invariants are violated.

## Required test categories

Implementations SHOULD include:
- unit tests (functional correctness),
- invariant tests (CR/SR, pause behavior, coverage gates),
- fuzz tests (oracle noise, ETH refund correctness, fund edge cases).

## Binding rules

- Tests must not encode hardcoded genesis constants.
- Tests must reference parameters supplied at deployment time.
- Failing an invariant test invalidates the implementation, even if unit tests pass.

## Acceptance

An implementation is acceptable only if:
- all invariant tests pass,
- all pause/revert conditions behave as specified,
- observability surfaces required by the checklist are verifiable.

## Reference

See:
- `spec/verification_checklist.md`
