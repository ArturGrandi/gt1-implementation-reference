# GT 1.0 — Verification Matrix (Binding)

Status: Binding (verification planning artifact)

This matrix maps each binding requirement to:
- modules (where it must hold),
- verification method (unit / invariant / fuzz / simulation),
- observable signals (events/views),
- pass/fail criteria (revert/pause/unchanged).

Genesis constants and thresholds are defined ONLY in:
- spec/genesis.md

This file MUST NOT duplicate genesis constants.

References:
- spec/verification_checklist.md (acceptance gate)
- spec/security.md (stress cases)
- spec/operations.md (rails & routing)
- spec/architecture.md (module boundaries)
- spec/time_domain.md (canonical time domain)

---

## Legend

Verification method:
- UNIT = deterministic unit tests
- INV = invariant/property tests
- FUZZ = fuzzing with randomized inputs
- SIM = higher-level simulations (scenarios)

Expected outcome:
- REVERT = tx must revert
- PAUSE = issuance/op must pause
- CONTINUE = safe ops continue
- UNCHANGED = internal price / meaning unchanged
- REDIRECT = mint redirected to Time Capital

Primary modules (canonical names, see spec/architecture.md):
- CORE = Core Accounting & State
- FUNDS = Funds & Ledgers (System/Liquidity/TC/EAS L1+L2)
- MINT = Mint Engine
- VAL = Valuation Issuance
- ORACLE = Oracle Adapter
- RAILS = Time Capital Purchase Rails
- GAS = GasReserve module
- EAS = Emergency Asset Segregation (L1+L2)

---

## Matrix

### A) Canonical documentation rules

| Requirement | Modules | Method | Signals / Observability | Expected | Pass criteria |
|---|---|---|---|---|---|
| Genesis constants exist only in `spec/genesis.md` | N/A | UNIT | repo scan / CI text scan | UNCHANGED | No numeric genesis constants appear outside `spec/genesis.md` |
| Cross-links between spec files exist | N/A | UNIT | repo scan | UNCHANGED | architecture↔security↔operations links present; checklist links present |
| Canonical time domain (Grand Time) | CORE/MINT/FUNDS/VAL | UNIT + INV | explicit “time_domain” helpers; audit notes | UNCHANGED | No invariant/prediction evaluated in external/mixed time units |

---

### B) Non-negotiable invariants (must never break)

| Requirement | Modules | Method | Signals / Observability | Expected | Pass criteria |
|---|---|---|---|---|---|
| CR/SR invariants enforced | CORE/FUNDS/MINT | INV + FUZZ | views: CR, SR; revert reasons | REVERT | Any action path that violates CR/SR must revert |
| 333-day stability standard enforced | CORE/MINT | INV + FUZZ | view: stability window state | REVERT | Any action that bypasses stability gating must revert |
| No forced conversion / liquidation engine | CORE/FUNDS/RAILS | INV + FUZZ | absence of liquidation paths; revert logs | UNCHANGED | No path triggers forced conversion/sell-off/liquidation |
| No reflexive mint adjustment on oracle noise | ORACLE/VAL/MINT | INV + FUZZ | oracle status; mint routing; price view | UNCHANGED | Oracle jitter never causes reflexive price/mint adjustment |
| Stablecoin-agnostic suspension containment | RAILS/FUNDS | SIM + INV | asset status flags; per-asset revert reasons | CONTINUE | Suspending one asset does not change invariants/price logic; other assets continue if safe |
| Emergency Asset Segregation L1 + L2 mandatory | FUNDS/EAS | UNIT + SIM | segregation flags; ledger views | UNCHANGED | Segregation does not change price logic or bypass gates; isolate assets as availability constraint |

---

### C) Oracle security & pause policy

| Requirement | Modules | Method | Signals / Observability | Expected | Pass criteria |
|---|---|---|---|---|---|
| Oracle role = reference valuation only | ORACLE/VAL | INV + FUZZ | oracle usage audit; events | UNCHANGED | Oracle cannot trigger sell-offs/forced conversions |
| Oracle failure ⇒ pause issuance + redirect mint + price unchanged | ORACLE/VAL/MINT/CORE | SIM + INV | oracle status; pause flag; mint redirection flag; price view | PAUSE + REDIRECT + UNCHANGED | On stale/invalid/inconsistent: issuance paused, mint redirected to TC, internal price unchanged |
| Oracle recovery ⇒ resume without discontinuity | ORACLE/VAL/MINT | SIM | pause flag transitions; price view | CONTINUE + UNCHANGED | Resume issuance without price discontinuity or hidden reallocation |

---

### D) Gas autonomy & GasReserve

| Requirement | Modules | Method | Signals / Observability | Expected | Pass criteria |
|---|---|---|---|---|---|
| No social transaction gas subsidy | CORE/RAILS/GAS | UNIT + INV | code audit; tx origin constraints | UNCHANGED | Protocol never pays gas for user tx; only ops tx use GasReserve |
| GasReserve < minGas ⇒ manual top-up (no auto-buy) | GAS/RAILS | SIM + UNIT | GasReserve balance; admin top-up event | UNCHANGED | No automatic market action required; manual external ETH restores minimum |

---

### E) ETH rail (Time Capital only) — mandatory gates

| Requirement | Modules | Method | Signals / Observability | Expected | Pass criteria |
|---|---|---|---|---|---|
| ETH rail enabled only when GasReserve < targetGas | GAS/RAILS | UNIT + SIM | view: rail enabled; GasReserve balance | REVERT / CONTINUE | When >= targetGas: ETH rail reverts; when < targetGas: may proceed (subject to other gates) |
| ETH valued via ETH/USD oracle (settlement asset only) | ORACLE/RAILS | UNIT + FUZZ | oracle feed status; settlement logs | UNCHANGED | Bonding/111-day rules & premium cap unchanged; only settlement differs |
| P_next_min preservation gate (System Fund coverage) | FUNDS/RAILS/CORE | INV + SIM | transfer event: System→Liquidity; revert reason | REVERT / CONTINUE | Must transfer ΔF_liq_USD=q*P from System to Liquidity; revert if System Fund would fall below required floor for P_next_min |
| ETH routing to GasReserve up to target + refund excess (v1) | GAS/RAILS | UNIT + FUZZ | retained/refunded ETH events; GasReserve delta | CONTINUE | Retained ETH fills GasReserve up to target; excess refunded same tx; delivered GUCT computed only from retained ETH |

---

### F) Observability (verification surfaces)

| Surface | Modules | Method | Expected | Pass criteria |
|---|---|---|---|---|
| GasReserve balance view | GAS | UNIT | UNCHANGED | Read-only view exists |
| ETH rail enabled/disabled view | GAS/RAILS | UNIT | UNCHANGED | Status derived from GasReserve vs target |
| retained/refunded ETH per ETH-TC purchase | GAS/RAILS | UNIT | UNCHANGED | Clear accounting; no ambiguity |
| System→Liquidity transfer amount per ETH purchase | FUNDS/RAILS | UNIT | UNCHANGED | Exact q*P coverage transfer visible |
| oracle status (valid/stale/inconsistent) + pause flag | ORACLE/VAL | UNIT | UNCHANGED | Observable without privileged access |
| valuation issuance pause state | VAL | UNIT | UNCHANGED | Exposed |
| mint redirection state (to Time Capital) | MINT | UNIT | UNCHANGED | Exposed |

---

## Binding note

This matrix is binding as a planning and verification mapping.
Acceptance remains defined by:
- spec/verification_checklist.md

Any new behavior requires an explicit spec patch approved by the project owner.
No economic redesign is permitted via contributions.
