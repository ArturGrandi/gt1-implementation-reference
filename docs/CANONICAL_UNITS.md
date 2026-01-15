# Canonical Units — GT 1.0

**Status:** Authoritative · Clarification-only  
**Scope:** Temporal primitives only (no economic redesign)

This document defines the minimal canonical temporal units used by GT 1.0
to make invariants, verification references, and diagrams machine-checkable.

This file is the **single source of truth** for time unit definitions.

---

## 1. Normative vs Informative Boundary

- **Normative:** Definitions and conversion rules in this document.
- **Informative:** Explanations in the research paper and non-normative docs.

If a conflict exists, this document prevails for GT 1.0 artifacts.

---

## 2. Base Canonical Unit

**Name:** Grand  
**Symbol:** G  
**Type:** Discrete canonical temporal unit

A *Grand* is the smallest indivisible time unit used by GT 1.0
for all invariants, limits, and verification references.

No fractional Grand is allowed.

---

## 3. Relation to Real Time

GT 1.0 anchors Grands to real time via a fixed daily partition.

**Definition:**
- 1 civil day = **10,000,000 G**
- Day boundary is defined relative to the GT epoch (see below).

This mapping is deterministic and does not depend on blockchain time.

---

## 4. GT Epoch

**Epoch reference:**  
2014-12-26T00:00:00 (Moscow Time)

All conversions between real time and canonical units
are computed relative to this epoch.

---

## 5. Conversion Rules (Normative)

- Conversion from real time to Grands is **floor-based**.
- Rounding up is **not permitted**.
- If an interval does not fully complete a Grand, it is discarded.

These rules are mandatory for:
- invariant evaluation
- verification matrices
- test scaffolding

---

## 6. Usage Constraint

Any invariant, rule, or limit that references time **MUST**:
- point to a canonical unit defined in this file, and
- reference an explicit conversion rule.

Artifacts that do not satisfy this are considered incomplete.

---

## 7. Out of Scope

This document does **not**:
- define economic value,
- define issuance or rewards,
- introduce governance or policy decisions.
