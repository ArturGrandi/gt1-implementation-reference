# Grand Time Protocol (GT 1.0)

# GT 1.0 — Controlled Reference Implementation

## Canonical Research Reference

This repository supports the published research paper:

**Time as a Non-Monetary Economic Primitive**  
DOI: https://doi.org/10.5281/zenodo.18190386

Status: research-only, spec-first economic protocol.  
No production deployment. No investment offering.

---

## Documentation Freeze (GT 1.0)

This repository represents a frozen documentation snapshot for GT 1.0.

- Economic invariants are fixed.
- Genesis parameters are fixed.
- Architecture boundaries are fixed.

Changes after this point may only be:
- clarifications,
- additional diagrams,
- verification artifacts.

No economic logic changes are permitted.

---

## Canonical Specification Set

### Controlled Reference Implementation

This repository contains the **controlled reference implementation** of
**Grand Time Protocol (GT 1.0)** — a time-based macroeconomic protocol
where **human time is treated as an economic primitive**.

---

## What this repository is

- A **spec-first**, verification-driven implementation of GT 1.0
- A reference for **auditing, research, and simulation**
- A foundation for long-horizon economic systems research

This repository is intended for:
- senior protocol engineers,
- auditors and formal verification specialists,
- researchers and academics,
- long-term institutional reviewers.

---

## What this repository is NOT

- ❌ Not a production deployment
- ❌ Not a commercial product
- ❌ Not a tokenomics playground
- ❌ Not a speculative experiment

Economic invariants are **fixed and non-negotiable**.

---

## Source of truth (important)

GT 1.0 follows strict **spec-first discipline**.

Canonical documents live in `/spec`:

- `spec/genesis.md` — deployment parameters & genesis
- `spec/architecture.md` — module boundaries & safety gates
- `spec/operations.md` — runtime behavior (rails, pauses, routing)
- `spec/security.md` — invariants & stress cases
- `spec/time_domain.md` — canonical Grand Time units
- `spec/verification_checklist.md` — acceptance criteria
- `spec/verification_matrix.md` — requirements × modules × tests

**Code must follow spec.  
Spec does not follow code.**

Canonical temporal units are defined in:

- `docs/CANONICAL_UNITS.md` (authoritative, normative)

An executable, non-normative mirror is provided for review convenience only:

- `reference/time_units.py`

In case of any discrepancy, **documentation prevails**.

---

## How to start (recommended)

If you are new here, begin with:

➡️ **[`docs/START_HERE.md`](docs/START_HERE.md)**

It provides a 10-minute guided path through the system.

For temporal semantics and invariants, review in this order:

1. `docs/CANONICAL_UNITS.md`
2. `reference/time_units.py` (executable mirror)
3. Relevant sections in `spec/time_domain.md`
   
---

## Research Review (Single Entry Point)

All technical review, critique, and research discussion for GT 1.0  
is consolidated in a **single GitHub Issue**:

➡️ **Research Review & Critical Questions**  
https://github.com/ArturGrandi/gt1-implementation-reference/issues/1

Please do **not** open additional issues.  
This repository follows a **spec-first, review-driven** process.

---

## Tests & verification

Correctness is validated through:
- invariant tests,
- fuzzing,
- time-domain simulations,
- explicit acceptance criteria.

Passing tests is not sufficient if invariants are violated.

---

## Contributions

Contributions are welcome **only within defined scope**.

Before opening an Issue or PR, read:
- `CONTRIBUTION_GUIDELINES.md`
- `.github/ISSUE_TEMPLATE/`
- `.github/PULL_REQUEST_TEMPLATE.md`

Economic redesign proposals are not accepted in GT 1.0.

---

## Status

**GT 1.0 status:**  
✔ Specs frozen  
✔ Security model defined  
✔ Verification framework in place  
✔ Controlled implementation in progress  

---

## Final note

Grand Time Protocol explores an alternative economic foundation
where **time is not a UI artifact, but a first-class economic unit**.

If you are interested in correctness, invariants, and long-horizon systems —
you are in the right place.

---

## Related research (contextual, non-normative)

GT 1.0 is part of a broader research track exploring
formula-constrained and non-governance-based economic systems.

The following publications provide **theoretical and methodological context only**
and do **not** define protocol semantics, invariants, genesis parameters,
or any normative rules for GT 1.0:

- *Time as a Non-Monetary Economic Primitive*  
  Zenodo (CERN) — DOI: https://doi.org/10.5281/zenodo.18190386

- *Formula-Constrained Economic Systems Without Governance Voting*  
  Zenodo (CERN) — DOI: https://doi.org/10.5281/zenodo.18275133

All authoritative and normative definitions for GT 1.0
remain defined exclusively in this repository.
