# GT 1.0 — Verification Checklist (Binding)

Status: Binding (acceptance & verification)

This checklist defines verification targets for the GT 1.0 controlled reference implementation.
It is not a discussion document and must not be used to propose economic redesign.

Genesis constants are defined ONLY in:
- spec/genesis.md

All verification below must reference spec/genesis.md for parameters and must not duplicate constants.

---

## 0) Verification scope & rules

- Repository is research/simulation/verification only (no production claims).
- Pass/Fail is based on:
  - invariants (must never break),
  - hard safety gates (must revert),
  - pause policies (must pause & redirect mint; must not force conversions),
  - consistency across spec files.

---

## 1) Spec consistency checks (Docs as code)

### 1.1 Canonical placement of constants
PASS if:
- spec/genesis.md is the only file that contains numeric genesis constants and thresholds (P0, M, minGas, targetGas, prehistory days, allocations, bootstrap minimum).
FAIL if:
- any other file restates genesis constants instead of referencing spec/genesis.md.

### 1.2 Cross-links are present
PASS if:
- spec/architecture.md references spec/security.md and spec/operations.md.
- spec/operations.md references spec/security.md and spec/architecture.md.
- spec/security.md references spec/operations.md (gas/ETH rail cases) and spec/architecture.md (module boundaries).

---

## 2) Invariants (Must never break)

### 2.X Canonical time domain (Grand Time)

PASS if:
- all time-based invariants, windows, mint gates, stability periods,
  prediction graphs, historical and epochal accounting
  are evaluated exclusively in Grand Time units,
- external timestamps (block time, oracle time, wall-clock)
  are used only as transport or ordering signals.

FAIL if:
- any invariant, prediction, or safety rule
  is evaluated directly in external or mixed time units,
- oracle timestamp drift can affect economic meaning or mint logic.

### 2.1 CR/SR invariants are enforced
PASS if:
- contracts expose read-only views for CR/SR state and the system cannot perform actions that violate CR/SR invariants.
FAIL if:
- any action path can bypass CR/SR enforcement.

### 2.2 333-day stability standard is enforced
PASS if:
- stability rule(s) defined by GT 1.0 are enforced in the mint/price pipeline.
FAIL if:
- stability is optional or bypassable.

### 2.3 No protocol fees on stable in/out
PASS if:
- deposit/redeem (stable rails) have 0% protocol fees (gas only).
FAIL if:
- any fee is applied by default or conditionally.

### 2.4 Multi-asset liquidity + Emergency Asset Segregation is mandatory
PASS if:
- Level 1 + Level 2 segregation exists and can be exercised without changing internal price logic.
FAIL if:
- suspension/segregation triggers price collapse or changes mint logic.

---

## 3) Oracle security (Binding behavior)

### 3.1 Oracle role is reference valuation only
PASS if:
- oracle input is used only for reference valuation and gating.
FAIL if:
- oracle triggers sell-offs, forced conversions, or liquidation logic.

### 3.2 Oracle failure handling
Trigger conditions:
- stale feed, inconsistent feed, invalid answer, missing feed.

PASS if, upon oracle failure:
- valuation issuance is paused,
- mint is redirected to Time Capital,
- protocol internal/reference price remains unchanged,
- no forced asset conversion occurs.

FAIL if:
- oracle failure causes reflexive price/mint adjustment,
- oracle failure triggers liquidation/sell-offs,
- price changes or fund redistribution occur as a side-effect.

---

## 4) Gas autonomy & GasReserve (Binding behavior)

### 4.1 No social transaction subsidy
PASS if:
- protocol does not pay gas for users (“social” tx).
FAIL if:
- any user transaction path is subsidized.

### 4.2 GasReserve thresholds (from spec/genesis.md)
PASS if:
- GasReserve is treated as ops-only infrastructure (ETH/WETH),
- below minGas => manual external top-up (admin transfer), not an automatic market action.

FAIL if:
- protocol auto-buys ETH to restore minGas,
- GasReserve is treated as liquidity coverage.

---

## 5) ETH TC purchase rail (Binding safety gates)

### 5.1 Enable/disable by GasReserve vs targetGas
PASS if:
- buyFromTimeCapitalWithETH() is enabled only when GasReserve < targetGas,
- reverts when GasReserve >= targetGas.
FAIL if:
- ETH rail works when GasReserve >= targetGas.

### 5.2 ETH/USD valuation
PASS if:
- retained ETH is valued via ETH/USD oracle for USD-equivalent settlement,
- bonding/111-day rules and premium cap (44%) remain unchanged.
FAIL if:
- ETH rail changes bonding logic or premium cap.

### 5.3 P_next_min preservation gate (System Fund coverage)
For an ETH purchase delivering q GUCT at internal price P:

PASS if:
- protocol immediately moves USD accounting coverage from System Fund to Liquidity Fund:
  ΔF_liq_USD = q * P
- sourced from System Fund accounting, NOT from incoming ETH.
- tx reverts unless:
  F_sys_USD - (q * P) >= F_sys_req_USD(P_next_min)

FAIL if:
- coverage is not moved,
- coverage uses incoming ETH instead of System Fund accounting,
- tx succeeds while breaking the required System Fund floor for P_next_min.

### 5.4 ETH routing & refund correctness (v1)
PASS if:
- ETH is routed to GasReserve up to targetGas,
- any excess ETH is refunded within the same tx,
- delivered GUCT is computed ONLY from retained ETH.
FAIL if:
- no refund,
- overpayment buys GUCT implicitly,
- retained vs refunded ETH is ambiguous.

---

## 6) Stablecoin-agnostic behavior (USDT/USDC/DAI)

### 6.1 Asset suspension containment
PASS if:
- a supported stable can be suspended without affecting:
  - internal price logic,
  - invariants,
  - other settlement rails (where applicable).
FAIL if:
- suspension triggers price collapse or changes mint allocation.

---

## 7) Observability requirements (Must expose verification surfaces)

PASS if the implementation exposes read-only views/events for:
- GasReserve balance
- ETH rail enabled/disabled status (derived from GasReserve vs targetGas)
- retained ETH and refunded ETH per ETH-TC purchase
- System Fund -> Liquidity Fund transfer amount (USD accounting) per ETH-TC purchase
- oracle status (valid/stale/inconsistent) and pause flag
- valuation issuance pause state
- mint redirection state (to Time Capital)

FAIL if:
- verification cannot observe these states without privileged access.

---

## 8) Acceptance definition (Controlled reference implementation)

A build is acceptable (PASS) only if:
- all invariants (Section 2) hold,
- oracle failure handling (Section 3) matches spec exactly,
- gas autonomy + ETH rail behavior (Sections 4–5) matches spec exactly,
- stablecoin-agnostic suspension containment (Section 6) holds,
- observability surfaces (Section 7) exist.

Any deviation requires a spec patch with explicit project owner approval.
No economic redesign is permitted via contributions.
