# GT 1.0 — Documentation Freeze Marker (v1.0)

Status: Binding · Research-only · Spec-first

This file marks the **official documentation freeze** for GT 1.0.

The purpose of this freeze is to protect semantic integrity while allowing
controlled implementation and verification work to proceed.

---

## What is frozen

The following elements are **frozen and binding** for GT 1.0:

- Economic meaning and scope
- Architectural boundaries
- Security model and invariants
- Genesis parameters and constants
- Operational rules and safety gates
- Failure handling and containment logic

These are defined exclusively in the `/spec` directory and related
documentation referenced therein.

No economic redesign is permitted under GT 1.0.

---

## What is NOT frozen

The following may continue to evolve:

- Reference implementation code
- Simulation tooling
- Test suites and verification artifacts
- CLI utilities and developer tooling
- Documentation clarifications (non-semantic)
- Diagrams and visual explanations

Such changes MUST remain consistent with the frozen GT 1.0 specification.

---

## Change policy

Allowed changes:
- Clarifications that do not alter meaning
- Additional diagrams and verification artifacts
- Implementation details consistent with spec
- Bug fixes in code and tests

Disallowed changes:
- Economic logic changes
- Invariant modifications
- Parameter changes outside `spec/genesis.md`
- Tokenomics, investment, or deployment claims

Any change to frozen elements requires an **explicit specification revision**
(e.g., GT 1.1 or GT 2.0).

---

## Intent

This freeze enables:
- External technical and academic review
- Controlled implementation by contributors
- Clear separation between research specification and code iteration

GT 1.0 is intended as a **controlled reference implementation**, not a
production system.

