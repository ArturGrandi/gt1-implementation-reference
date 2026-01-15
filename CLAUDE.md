<!-- INTERNAL: Developer-only AI guidance. Not part of GT 1.0 public specification or narrative. -->
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Grand Time Protocol (GT 1.0) is a controlled reference implementation of a time-based macroeconomic protocol supporting the research paper "Time as a Non-Monetary Economic Primitive" (DOI: https://doi.org/10.5281/zenodo.18190386).

**Status:** Research-only, spec-first, documentation frozen. No production deployment.

## Critical Constraints

### Spec-First Discipline
- Code MUST follow specs; specs do NOT follow code
- All numeric constants live ONLY in `spec/genesis.md` — never duplicate elsewhere
- No economic redesign permitted in GT 1.0

### Non-Negotiable Invariants
- CR/SR invariants must never break
- 333-day stability standard is mandatory
- No forced asset conversion or liquidation logic
- No oracle-driven sell-offs
- No reflexive mint adjustments
- Zero protocol fees on stablecoin in/out (gas only)

### Temporal Canonicality
All economic meaning is evaluated exclusively in **Grand Time units**. External time (UTC, block time) is permitted only as transport/UI layer, never for economic meaning.

## Repository Structure

```
spec/           # Binding specifications (authoritative source of truth)
  genesis.md      # ONLY source for numeric constants and deployment parameters
  architecture.md # Module boundaries and safety gates
  operations.md   # Runtime rules: gas autonomy, ETH rail, routing
  security.md     # Invariants, pause logic, failure containment
  time_domain.md  # Grand Time canonicality
  verification_checklist.md  # Acceptance gate (PASS/FAIL criteria)
  verification_matrix.md     # Requirements × modules × tests mapping

contracts/      # Smart contract implementation (Foundry/Solidity)
test/           # Test suite (canonical directory, not "tests/")
  unit/           # Functional correctness
  invariant/      # Must-never-break properties
  fuzz/           # Adversarial input testing
  sim/            # Grand Time scenario simulations

docs/           # Developer documentation
  diagrams/       # Conceptual SVGs (no numbers/formulas)
```

## Build & Test Commands

No automated build pipeline configured yet (spec-only stage). When implemented, tests will use Foundry framework with `test/` as the canonical directory.

## Reading Order (5-10 minutes)

1. `spec/architecture.md`
2. `docs/diagrams/architecture-overview.svg`
3. `spec/security.md`
4. `spec/operations.md`
5. `spec/verification_checklist.md`
6. `test/README.md`

## AI Review Protocol

When performing code review, follow `docs/AI_REVIEW_QUESTIONNAIRE.md`:

**Allowed:**
- Invariant violation detection
- Ambiguous boundary identification
- Failure containment completeness checking
- Spec consistency verification
- Cite exact file paths and section headings

**Prohibited:**
- Tokenomics or incentive proposals
- Roadmap/milestone suggestions
- Protocol redesign or new economic logic
- Production deployment recommendations

**Output format:** Structured findings with ID, Severity (S0-S3), Area, Evidence, Claim, Impact, Fix.

## PR Requirements

All PRs must:
- Reference exact spec sections being implemented
- Confirm temporal canonicality (Grand Time units only)
- Inject genesis constants (never hardcode)
- Preserve CR/SR/stability invariants
- Include tests for behavioral changes
- Explicitly state no economic redesign

## Key Genesis Parameters (Reference Only — See spec/genesis.md)

- Virtual Prehistory: 3333 days
- Daily Mint: 10,000,000 GUCT/day
- Initial Price P0: 0.00000001 USD per GUCT
- Gas thresholds: minGas 0.2 ETH, targetGas 1.1 ETH
- Population baseline N0: deployment parameter (not hardcoded)

## Failure Containment

Three failure paths with visual diagrams in `docs/diagrams/`:

1. **Oracle failure** → Pause valuation issuance, redirect mint to Time Capital, preserve reference price
2. **Gas depletion** → ETH rail enabled only when GasReserve < targetGas, refunds in same transaction
3. **Stablecoin suspension** → Per-asset pause only, price logic unchanged
