# GT 1.0 — Time Domain (Grand Time Canonicality)

Status: Binding

This document defines the canonical time domain for GT 1.0.
All economic meaning, windows, invariants, and predictive graphs are evaluated only in Grand Time units.

---

## 1) Binding rule

All protocol parameters, including but not limited to:
- prediction graphs of minimum growth,
- stability windows and time-based constraints,
- historical / epochal accounting and virtual prehistory,
- any “day-based” mint, gates, and schedules,

MUST be defined, measured, and applied exclusively in Grand Time units.

---

## 2) External time is transport only

External time systems (UTC, block timestamps, wall-clock days) are permitted only as:
- transport signals,
- UI/UX presentation layers,
- logging / observability metadata.

They MUST NOT change protocol calculations, invariants, price logic, or mint-gates.

---

## 3) Oracle timestamp non-dependence

Oracle timestamps may be used only for feed freshness validation (availability / staleness checks),
but MUST NOT define economic meaning or time-based invariants.

---

## 4) References

- spec/genesis.md — canonical start conditions (T0, virtual prehistory, M)
- spec/architecture.md — module boundaries
- spec/operations.md — runtime operational rules
- spec/security.md — invariants and stress cases
