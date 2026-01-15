# Response to Critical Findings

**Review:** claude_code_review_2026-01-14.md
**Status:** Acknowledged

---

## GT1-FIND-001: Grand Time Unit Not Defined

**Acknowledged.**

Grand Time is defined in the canonical research paper (DOI: 10.5281/zenodo.18190386). The specification repository is a supporting artifact; the paper is the primary source.

Clarification for spec/time_domain.md may be added as a non-semantic documentation update referencing the paper's definition.

---

## GT1-FIND-002: CR/SR Invariants Not Defined

**Acknowledged.**

CR (Coverage Ratio) and SR (Stability Ratio) are defined in the canonical research paper. The specification assumes familiarity with the paper's economic model.

A glossary entry or spec appendix may be added as clarification.

---

## GT1-FIND-003: 333-Day Stability Standard Not Defined

**Acknowledged.**

The 333-day stability standard is derived from the paper's economic model. The specification references it as a binding constraint without restating the paper's derivation.

Clarification pointing to the paper section may be added.

---

## GT1-FIND-004: P_next_min Calculation Not Specified

**Acknowledged.**

P_next_min (predicted next minimum price) calculation is defined in the canonical research paper. The specification enforces the gate without duplicating the formula.

This is intentional to maintain single-source authority. Implementation must derive from the paper.

---

## GT1-FIND-005: 111-Day Constraint Not Defined

**Acknowledged.**

The 111-day constraint relates to the bonding window and small-purchase pricing rule defined in the paper. The specification references but does not restate the economic logic.

Clarification linking to the paper section may be added.

---

## Resolution Path

All five critical findings reference concepts defined in the canonical research paper rather than the specification repository.

Per `HOW_TO_READ.md`: "This repository does not introduce new economic claims. It encodes and constrains the paper's concepts."

Acceptable resolution: Add a glossary or appendix document that explicitly links undefined terms to their paper definitions, without restating economic formulas.

---

*Response complete.*
