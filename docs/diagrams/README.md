# GT 1.0 — Diagrams (SVG, Conceptual Only)

Status: Reference (documentation aid)

These diagrams are **conceptual** and exist to provide instant boundary comprehension.
They contain **no numbers**, **no formulas**, and **no tokenomics**.

Binding rules live in `/spec/*.md`. Diagrams must never restate genesis constants.

## Rules (binding for diagrams)

- **SVG only**
- **One diagram = one concept / one risk**
- **No numeric parameters**
- **No tokenomics**
- **No formulas**
- Label **on-chain vs off-chain** boundary when relevant
- Use plain language; diagrams must be readable by non-technical reviewers

## Files

- `architecture-overview.svg` — system boundaries and module map
- `funds-flow.svg` — conceptual funds & ledger flow
- `oracle-failure-path.svg` — pause + mint redirection containment
- `gas-depleted-path.svg` — ops continuity only, no economic impact
- `stablecoin-suspended-path.svg` — asset isolation, no price logic change (recommended)
