# START HERE — GT 1.0 Controlled Reference Implementation

Welcome.

This repository contains the **controlled reference implementation** of
**Grand Time Protocol (GT 1.0)**.

This is NOT a production system.
This is a **spec-first, verification-driven implementation** intended for:
- senior protocol engineers,
- auditors,
- researchers,
- academic reviewers,
- long-horizon funds.

---

## 1) What this is (and is not)

### This IS:
- a binding reference implementation of GT 1.0,
- aligned strictly to written specifications,
- designed for correctness, safety, and verification,
- intended for research, simulation, and audit.

### This is NOT:
- a production deployment,
- a commercial system,
- a place for economic redesign discussions,
- a fast-moving experimental playground.

If you are looking for speculative tokenomics — this is not the right place.

---

## 2) Source of truth (mandatory)

GT 1.0 follows **spec-first discipline**.

The only canonical sources are:

- `spec/genesis.md` — **all deployment constants & genesis parameters**
- `spec/architecture.md` — module boundaries & safety gates
- `spec/operations.md` — runtime rules (rails, pauses, routing)
- `spec/security.md` — invariants & stress cases
- `spec/time_domain.md` — canonical Grand Time units
- `spec/verification_checklist.md` — acceptance gate
- `spec/verification_matrix.md` — requirements × modules × tests

**Code MUST follow specs.  
Specs do NOT follow code.**

---

## 3) How to read this repository (10-minute path)

Recommended order:

1. `spec/genesis.md`
2. `spec/architecture.md`
3. `spec/security.md`
4. `spec/operations.md`
5. `spec/verification_checklist.md`
6. `spec/verification_matrix.md`
7. `test/README.md`

After this, you should understand:
- invariants,
- safety model,
- what must never break,
- how correctness is verified.

---

## 4) Contribution rules (important)

Before opening an Issue or PR, read:

- `CONTRIBUTION_GUIDELINES.md`
- `.github/ISSUE_TEMPLATE/`
- `.github/PULL_REQUEST_TEMPLATE.md`

### Hard rules:
- No economic redesign proposals.
- No changes to invariants without explicit owner approval.
- All changes MUST reference spec sections.
- Tests are required for any behavioral change.

---

## 5) Tests & verification

All correctness is validated via:

- `test/unit/` — functional correctness
- `test/invariant/` — must-never-break properties
- `test/fuzz/` — adversarial inputs
- `test/sim/` — time-based scenarios (Grand Time units only)

Passing tests is **not sufficient** if invariants are violated.

---

## 6) AI / UI note (important)

Any AI or UI integration:
- is **read-only**,
- cannot execute transactions,
- cannot hold keys,
- must be grounded strictly via spec-only RAG.

AI is an **assistant**, not an actor.

---

## 7) If you want to contribute

Start by:
- opening an Issue using the provided template,
- clearly stating which spec section you are implementing or verifying,
- proposing tests first, code second.

We value:
- correctness over speed,
- clarity over cleverness,
- invariants over features.

---

## 8) Final note

GT 1.0 is built with the assumption that:
**time is an economic primitive**, not a UI detail.

If this resonates with you — welcome.
