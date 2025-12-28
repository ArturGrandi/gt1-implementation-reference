# GT 1.0 — Implementation Freeze Notice

Status: Active (GT 1.0)

This repository represents a controlled reference implementation of the
GT 1.0 protocol stage.

It is spec-first, research-oriented, and intended for simulation,
verification, and audit-style review — not for production deployment.

---

## 1) Scope of Freeze (GT 1.0)

The following elements are considered **frozen for GT 1.0** in this repository:

- economic meaning and core invariants,
- fund mechanics (System Fund, Liquidity Fund, Time Capital),
- CR / SR invariants,
- 333-day stability standard,
- daily mint mechanics and mint-gate rules,
- valuation pause logic,
- bonding logic and premium caps,
- multi-asset liquidity design,
- gas autonomy model (no social transaction subsidy),
- ETH Time Capital purchase rail (enable/disable rules, refund correctness, safety gates),
- mining parity semantics (uniform 1:1 accrual rate),
- verification as access control (ownership and usage rights, not higher mining rate).

All binding rules are defined exclusively under the `/spec` directory.

---

## 2) Change Policy

Pull requests MUST NOT:

- introduce economic redesign,
- modify accrual or mining semantics,
- change genesis parameters,
- alter fund mechanics or invariants,
- reinterpret verification as a multiplier,
- introduce speculative, financial, or production-oriented features.

Changes are permitted only if they:

- implement already binding specifications,
- add tests, simulations, or verification tooling,
- improve documentation clarity without semantic changes,
- are explicitly authorized by the project owner via directive.

---

## 3) Directive-Driven Updates

Any protocol-level change or semantic update is applied **only** through
explicit **Implementation Directives** issued by the project owner.

Such directives:

- apply within the GT 1.0 stage unless explicitly stated otherwise,
- are committed as discrete, auditable changes,
- do not retroactively reinterpret prior specifications.

Subsequent protocol stages (e.g. GT 1.1, GT 2.0) may be defined **only**:
- after full implementation of GT 1.0, or
- if strictly required during GT 1.0 implementation.

---

## 4) Non-Production Disclaimer

This repository:

- is not a live protocol,
- does not imply deployment readiness,
- does not solicit investment,
- does not promise returns or yields.

Any use outside research, simulation, and verification is at the user’s own risk.

---

## 5) Canonical References

- `spec/genesis.md` — canonical start conditions and deployment parameters
- `spec/operations.md` — runtime operational rules
- `spec/security.md` — invariants and stress cases
- `spec/architecture.md` — module boundaries and interaction contracts
