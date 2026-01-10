# How to Read This Repository (GT 1.0)

This repository is a **controlled reference implementation** supporting the
published research paper:

**Time as a Non-Monetary Economic Primitive**  
DOI: https://doi.org/10.5281/zenodo.18190386

It is designed for researchers, senior engineers, auditors, and analysts who
need to understand the system **correctly and efficiently**.

---

## What this repository IS

- A **spec-first, research-only** reference implementation of GT 1.0
- A formalization of economic meaning, invariants, and safety constraints
- A verification-oriented architecture (invariants > code > tests)
- A supporting artifact to the canonical research paper (not a replacement)

---

## What this repository is NOT

- NOT a production-ready system
- NOT an investment offering
- NOT a token launch or tokenomics proposal
- NOT a governance or DAO implementation
- NOT optimized for UX, performance, or MEV resistance

---

## Canonical source of truth

The **primary and immutable source** of authorship and economic meaning is:

> **Time as a Non-Monetary Economic Primitive** (Zenodo, CERN)  
> DOI: https://doi.org/10.5281/zenodo.18190386

This repository **does not introduce new economic claims**.
It encodes and constrains the paper’s concepts.

Within the repository:

- **Numeric constants & deployment parameters**  
  → `spec/genesis.md` (ONLY source)
- **Time domain definition**  
  → `spec/time_domain.md`
- **Economic invariants & failure behavior**  
  → `spec/security.md`

---

## Recommended reading order (≈ 5–10 minutes)

1. **README.md**  
   High-level framing and research status.

2. **spec/architecture.md**  
   Module boundaries, on-chain vs off-chain separation, mandatory gates.

3. **docs/diagrams/architecture-overview.svg**  
   Visual system boundaries (conceptual, no numbers).

4. **spec/security.md**  
   Binding invariants, pause/containment logic, non-goals.

5. **spec/operations.md**  
   Gas autonomy, ETH rail, operational constraints.

6. **spec/verification_checklist.md**  
   Acceptance criteria (pass/fail authority).

Optional deep dive:
- `spec/verification_matrix.md`
- `test/README.md`

---

## Where diagrams fit

All diagrams are **conceptual SVGs** located in:

docs/diagrams/

Rules:
- No numbers
- No formulas
- No tokenomics
- One diagram = one concept or one risk

Diagrams **do not define rules** — they visualize rules defined in `/spec`.

---

## How correctness is verified

Correctness is defined by **invariants**, not by test success alone.

- All acceptance criteria live in:  
  `spec/verification_checklist.md`
- Tests in `/test` exist to **support**, not replace, invariant verification
- Any implementation that violates an invariant is **non-acceptable**,
  even if it compiles or passes partial tests

---

## Who this repository is for

This repository is intended for:

- Senior blockchain / protocol engineers
- Academic researchers (economics, systems, cryptography)
- Auditors and verification specialists
- Journalists and analysts reviewing protocol architecture

It is **not** intended for:
- retail users,
- traders,
- non-technical DAO participants.

---

## Status

GT 1.0 documentation is **binding within scope** and intended to be
**frozen after final review**.

Subsequent versions must be explicit (GT 1.1, GT 2.0) and non-implicit.
