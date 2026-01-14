# GT 1.0 — Request for Technical Review

Status: Research-only · Spec-first · Controlled reference implementation

This repository represents a **controlled reference implementation** of the
**Grand Time Protocol (GT 1.0)**, supporting the published research paper:

**Time as a Non-Monetary Economic Primitive**  
DOI: https://doi.org/10.5281/zenodo.18190386

Economic invariants, system boundaries, and core semantics are **fixed**.

---

## Purpose of this request

We are seeking **technical review** from senior protocol engineers,
formal verification specialists, and systems researchers.

The goal is to validate:

- architectural correctness,
- safety and containment under failure,
- consistency between specification, diagrams, and verification artifacts.

This is **not** a request for product feedback, tokenomics ideas, or business input.

---

## Scope of review (what we ask you to review)

Please focus on:

### 1. Architecture & boundaries
- Module separation and responsibilities
- On-chain vs off-chain boundaries
- Mandatory control paths and gates

Primary reference:
- `spec/architecture.md`
- `docs/diagrams/architecture-overview.svg`

---

### 2. Security & failure containment
- Oracle failure handling
- Gas depletion behavior
- Stablecoin suspension containment
- Absence of reflexive or liquidation logic

Primary reference:
- `spec/security.md`
- Risk-path diagrams in `docs/diagrams/`

---

### 3. Invariants & correctness guarantees
- CR/SR invariants
- Stability standard enforcement
- Non-negotiable constraints

Primary reference:
- `spec/security.md`
- `spec/verification_checklist.md`

---

### 4. Verification completeness
- Whether verification targets fully cover binding invariants
- Whether any invariant lacks an observable or test surface

Primary reference:
- `spec/verification_checklist.md`
- `spec/verification_matrix.md`

---

## Explicitly out of scope (not requested)

Please do **not** review or propose changes regarding:

- tokenomics or monetary policy redesign,
- speculative market behavior,
- UI / UX design,
- production readiness or deployment strategy,
- investment, valuation, or governance opinions.

Such proposals will be closed without discussion.

---

## How to review (recommended order)

1. `spec/genesis.md` — canonical parameters (no other source of constants)
2. `spec/architecture.md` — system boundaries and gates
3. `spec/security.md` — invariants and failure handling
4. `docs/diagrams/` — conceptual system and risk visualization
5. `spec/verification_checklist.md` — acceptance criteria
6. `spec/verification_matrix.md` — requirement-to-test mapping

---

## AI-Assisted Review (Optional, Strict Mode)

AI-assisted reviews (e.g. Claude Code) are explicitly allowed **only** if they follow the strict review protocol defined in:

**docs/AI_REVIEW_QUESTIONNAIRE.md**

This questionnaire enforces:

- senior-level protocol engineering perspective,
- strict spec reading (no invention, no redesign),
- invariant- and boundary-focused critique,
- structured, actionable findings.

AI reviews **must not** introduce:
- tokenomics,
- roadmap suggestions,
- architectural redesign,
- speculative features.

AI output that does not follow the defined format or violates scope
will be ignored.

The goal of AI-assisted review is **to surface blind spots and
consistency issues**, not to replace human judgment.

## How to submit feedback

- Use **GitHub Issues** for architectural or security observations.
- Reference **specific spec sections** where possible.
- PRs are accepted **only** for:
  - clarifications,
  - documentation consistency,
  - verification artifacts.

Economic redesign proposals are not accepted in GT 1.0.

---

## Repository status

- Research-only
- Specifications frozen
- Security model defined
- Verification framework in place
- Controlled implementation in progress

Thank you for contributing your expertise to a long-horizon,
non-speculative economic systems research effort.
