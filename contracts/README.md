# GT 1.0 — Contracts (Controlled Reference Implementation)

This directory contains smart contracts implementing GT 1.0 strictly according to `/spec`.

## Binding rules

- This is a controlled reference implementation (research / simulation only).
- No economic redesign is permitted in code.
- All numeric genesis parameters MUST be injected from `spec/genesis.md`
  (via constructor/init parameters or config wiring).
- Genesis constants MUST NOT be hardcoded.

## Scope

Contracts in this directory are expected to implement:
- module boundaries defined in `spec/architecture.md`,
- operational rules in `spec/operations.md`,
- security invariants in `spec/security.md`,
- acceptance criteria in `spec/verification_checklist.md`.

## Prohibited changes

Pull requests MUST NOT:
- introduce new economic parameters,
- modify CR/SR logic,
- alter mint-gates or stability rules,
- reinterpret oracle semantics,
- bypass coverage or pause gates.

Such PRs will be rejected unless accompanied by an approved spec patch.

## Reference

Start with:
- `spec/contract_map_v2.md`
