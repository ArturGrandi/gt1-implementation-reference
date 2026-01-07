# Simulation Tests — GT 1.0

Scope: Binding (time & scenario simulation)

This directory contains scenario-level simulations.
All time progression MUST use Grand Time units only.

---

## Mandatory scenarios

### 1) Oracle failure over time
- oracle failure persists across multiple GT days,
- mint redirected to Time Capital,
- recovery resumes without price discontinuity.

### 2) Inactivity & inheritance
- inactivity < 222 days → NO transfer,
- inactivity >= 222 days with opt-in → transfer executes,
- no heirs → no automatic transfer.

### 3) GasReserve lifecycle
- depletion → ops delayed only,
- manual top-up restores functionality,
- no economic meaning change.

---

## Time domain rule (binding)
All simulations MUST:
- use Grand Time units,
- ignore external wall-clock time except as transport.

---

## References (binding)
- spec/time_domain.md
- spec/verification_checklist.md
- spec/operations.md
