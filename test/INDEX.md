# GT 1.0 — Test Index (Binding Navigation)

Status: Binding (test navigation & traceability)

This index provides a canonical navigation layer between:
- the binding verification requirements (spec/verification_matrix.md),
- the acceptance gate (spec/verification_checklist.md),
- and the test skeleton directories under /test.

This file does not define new requirements.
It only defines where verification coverage must live.

Genesis constants and thresholds are defined ONLY in:
- spec/genesis.md

---

## 1) Canonical sources (binding)

Read in this order:
1) spec/verification_checklist.md (PASS/FAIL acceptance gate)
2) spec/verification_matrix.md (requirements × modules × methods × signals)
3) spec/security.md (stress cases & invariants)
4) spec/operations.md (runtime rails & routing)
5) spec/architecture.md (module boundaries)

---

## 2) Where each test type lives

- test/unit/  
  Deterministic functional tests: pure logic, revert reasons, event correctness.

- test/invariant/  
  Invariants that must never break (CR/SR, stability gates, P_next_min preservation).

- test/fuzz/  
  Property-based fuzzing around oracle failures, asset suspension, ETH refund correctness, rounding edges.

- test/sim/  
  Scenario simulations and time-based progression (Grand Time domain), including pause/resume behaviors.

---

## 3) Minimum required coverage map (binding)

The implementation MUST include coverage for the following requirement groups.
Details and exact criteria are defined in spec/verification_checklist.md and spec/verification_matrix.md.

### 3.1 Spec consistency & constants
Coverage must ensure:
- spec/genesis.md is the only place with genesis constants.
- other files reference but do not duplicate values.

Primary method:
- unit (static checks / CI lint later), plus manual review.

### 3.2 Oracle failure containment
Coverage must ensure:
- issuance pause on stale/invalid/inconsistent oracle,
- mint redirection to Time Capital,
- reference/internal price remains unchanged,
- no forced conversion / sell-offs / reflexive mint adjustment.

Primary methods:
- unit + sim + fuzz

### 3.3 Gas autonomy & ETH rail
Coverage must ensure:
- no social transaction subsidy,
- ETH TC rail enabled only when GasReserve < targetGas,
- revert at/above targetGas,
- refund correctness in the same tx,
- P_next_min preservation gate via System Fund coverage transfer.

Primary methods:
- unit + invariant + fuzz

### 3.4 Stablecoin suspension containment
Coverage must ensure:
- per-asset suspension pauses only that asset,
- internal price logic and invariants remain unchanged,
- other rails continue if safe.

Primary methods:
- unit + sim + fuzz

### 3.5 Emergency Asset Segregation (Level 1 + Level 2)
Coverage must ensure:
- segregation isolates designated assets without affecting price logic,
- cannot be abused to bypass mint-gates or coverage rules.

Primary methods:
- invariant + sim

### 3.6 UI / AI & Inheritance (access gating)
Coverage must ensure:
- AI interfaces have no execution or signing authority (read-only + guided actions only),
- AI outputs are grounded via spec-only RAG (no external truth source),
- inheritance executes ONLY with opt-in + inactivity >= 222 days,
- no path exists for automatic GUCT transfer to Time Capital.

Primary methods:
- unit (interface permission checks) + sim (inactivity scenarios)

---

## 4) Naming convention (recommended)

When tests are added, name files by requirement group:

- unit/oracle_pause_*.md / .ts / .sol (depending on framework)
- invariant/p_next_min_gate_*.*
- fuzz/eth_refund_*.*
- sim/inactivity_222d_*.*
- sim/stable_suspension_*.*
