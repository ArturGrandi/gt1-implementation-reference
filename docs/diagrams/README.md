# GT 1.0 — Diagrams (SVG)

Status: Supporting (visual explainer)

These diagrams provide a visual map of GT 1.0 boundaries, modules, and failure containment paths.

Rules:
- SVG only
- No numbers
- No formulas
- No tokenomics
- One diagram = one concept or one risk path
- Diagrams must not redefine the spec; they only visualize it

Canonical spec sources:
- spec/architecture.md
- spec/operations.md
- spec/security.md
- spec/genesis.md (only source of constants)

## Overview
- architecture-overview.svg — system boundaries (on-chain vs off-chain), module map, mandatory pause/redirect points
- funds-flow.svg — fund/ledger movement at a high level (no constants)
- oracle-failure-path.svg — oracle failure containment (pause issuance + redirect mint; no sell-offs)
- gas-depleted-path.svg — GasReserve depletion path (ops continuity only; no economic impact)
- stablecoin-suspended-path.svg — stable suspension containment (asset-level pause; invariants unchanged)
