# GT 1.0 — Controlled Reference Implementation (Non-Production)

This repository contains a **controlled reference implementation** of GT 1.0 for:
- research,
- simulation,
- testnet-style validation,
- formal verification alignment.

**Non-production scope:**
- No mainnet / production deployments are provided or implied.
- No investment, fundraising, or profit mechanisms are defined or supported here.
- No operational guarantees.

---

## Start Here

### Canonical Genesis (single source of truth)
All protocol start conditions and genesis numbers are defined **exclusively** in:

- `spec/genesis.md`
  
### Spec-first rule (binding)
All binding specifications for this repository live under `/spec`:

- `spec/genesis.md` — canonical genesis and deployment parameters
- `spec/operations.md` — runtime operational rules (rails, pauses, routing)
- `spec/security.md` — invariants and mandatory stress cases
- `spec/architecture.md` — module map and boundaries

Genesis numbers and constants MUST NOT be duplicated outside `/spec`.
Contracts and docs may reference spec files only.

Genesis constants **must not** be duplicated in other docs or in contract code (only references allowed).

### Protocol Spec (spec-first)
The binding GT 1.0 formular / protocol specification lives in:

- `gt1-formular-standard` (spec-first reference)

This repository exists to implement the spec under a controlled, non-production posture.

---

## Repository Structure

- `spec/` — controlled spec overlays and genesis placement (canonical)
- `contracts/` — reference contracts (non-production)
- `interfaces/` — Solidity interfaces aligned to the spec
- `docs/` — implementation notes, simulation guidance, verification notes

---

## Rules of Engagement

- Do not propose economic redesign here (CR/SR, 333-day stability, mint gates, Time Capital, bonding caps, multi-asset liquidity are fixed).
- Pull requests must be implementation-focused and aligned to the spec.
- Any change touching genesis parameters must be proposed **only** via `spec/genesis.md`.

---

## Related Repositories

- `grand-time-architecture` — research-only architecture and prior art (no code)
- `gt1-formular-standard` — GT 1.0 spec-first protocol standard (reference)
