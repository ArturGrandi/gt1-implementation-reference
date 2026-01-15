# GT 1.0 Specification Technical Review Report

**Mode:** S3 Analysis-Only | Read-Only | No Recommendations
**Scope:** spec/ directory, docs/AI_REVIEW_QUESTIONNAIRE.md, README.md
**Date:** 2026-01-14
**Reviewer:** Claude Code (claude-opus-4-5-20251101)

---

## Section 1: Undefined Core Definitions

### [CRITICAL] GT1-FIND-001: Grand Time Unit Not Defined

**File:** `spec/time_domain.md` Section 1
**Evidence:** "MUST be defined, measured, and applied exclusively in Grand Time units"

The specification mandates all economic meaning be evaluated in "Grand Time units" but never defines:
- What constitutes one Grand Time unit
- How Grand Time maps to any measurable quantity
- Whether Grand Time is continuous or discrete

This renders the temporal canonicality rule unenforceable as written.

---

### [CRITICAL] GT1-FIND-002: CR/SR Invariants Not Defined

**File:** `spec/security.md` Section 2, `spec/verification_checklist.md` Section 2.1
**Evidence:** "CR/SR invariants must never break" / "contracts expose read-only views for CR/SR state"

The specification repeatedly mandates CR/SR invariant preservation but never defines:
- What CR and SR represent
- What values constitute valid CR/SR states
- What conditions trigger a violation

Without definition, the invariant is unverifiable.

---

### [CRITICAL] GT1-FIND-003: 333-Day Stability Standard Not Defined

**File:** `spec/verification_checklist.md` Section 2.2, `spec/genesis.md` Section 9
**Evidence:** "333-day stability standard is enforced" / "333-day stability standard"

Referenced as non-negotiable but never defined:
- What property must be stable
- What the 333-day window represents
- What enforcement mechanism applies

---

### [CRITICAL] GT1-FIND-004: P_next_min Calculation Not Specified

**File:** `spec/operations.md` Section 4.2, `spec/security.md` Section 4.2
**Evidence:** "F_sys_USD - (q * P) >= F_sys_req_USD(P_next_min)"

The P_next_min preservation gate is a hard safety requirement, but:
- P_next_min calculation method is undefined
- F_sys_req_USD(P_next_min) function is not specified
- The relationship between P and P_next_min is not defined

This makes the coverage gate unimplementable.

---

### [CRITICAL] GT1-FIND-005: 111-Day Constraint Not Defined

**File:** `spec/operations.md` Section 3.3, `spec/verification_checklist.md` Section 5.2, `spec/contract_map_v2.md` Section 3.6
**Evidence:** "Bonding rules, 111-day constraints, and premium caps remain unchanged" / "111 daily shares => P_next_min"

The 111-day constraint is referenced in three spec files but never defined:
- What behavior is constrained
- What "111 daily shares" means
- How this interacts with bonding logic

---

### [MAJOR] GT1-FIND-006: Bonding Logic Not Specified

**File:** `spec/genesis.md` Section 9, `spec/contract_map_v2.md` Section 3.6
**Evidence:** "bonding logic (including premium caps)" / "bonding premium cap (44%)"

The 44% premium cap is mentioned but:
- The bonding mechanism itself is undefined
- When premium applies is not specified
- How premium is calculated is not specified

---

### [MAJOR] GT1-FIND-007: Oracle Staleness Criteria Explicitly Undefined

**File:** `spec/security.md` Section S3-C2
**Evidence:** "If the specification does not define concrete criteria (e.g., staleness thresholds), they are undefined"

The spec explicitly acknowledges oracle failure criteria are undefined while simultaneously mandating criterion-based containment. This creates an unresolvable gap.

---

### [MAJOR] GT1-FIND-008: Level 1 vs Level 2 Emergency Segregation Not Distinguished

**File:** `spec/security.md` Section 5.5, `spec/architecture.md` Section 3.2
**Evidence:** "Level 1 segregation isolates designated assets" / "Level 2 segregation isolates high-risk assets"

Both levels are referenced as mandatory but:
- The difference between Level 1 and Level 2 is undefined
- Criteria for which level applies is not specified
- Whether they can be applied concurrently is unclear

---

### [MAJOR] GT1-FIND-009: Mint-Gates Not Defined

**File:** `spec/architecture.md` Section 3.1, 3.3
**Evidence:** "enforces mint-gates and invariants" / "applies mint allocation rules and mint-gates"

Mint-gates are referenced as a core responsibility but:
- What conditions trigger mint-gates is undefined
- What mint-gates prevent or allow is unspecified
- Relationship to coverage gates is unclear

---

## Section 2: Internal Contradictions

### [MAJOR] GT1-FIND-010: Genesis Constant Duplication Violation

**File:** `spec/inheritance.md` Section 2
**Evidence:** "inactivityPeriod = 222 days"

`spec/genesis.md` Section 1 states: "All protocol start conditions... MUST be defined exclusively in this spec/genesis.md file."

`spec/verification_checklist.md` Section 1.1 states: "FAIL if: any other file restates genesis constants"

However, `spec/inheritance.md` contains "inactivityPeriod = 222 days" which is a numeric constant that should only appear in genesis.md. This violates the stated canonical placement rule.

---

### [MINOR] GT1-FIND-011: Stability Fund Inconsistent Definition

**File:** `spec/contract_map_v2.md` Section 3.4, `spec/architecture.md` Section 3.2
**Evidence:** "System Fund, Liquidity Fund, Stability Fund, Time Capital" vs "System Fund... Liquidity Fund... Time Capital"

`contract_map_v2.md` lists four funds including "Stability Fund" while `architecture.md` lists only three funds (omitting Stability Fund). The specification is inconsistent on whether Stability Fund exists as a distinct ledger.

---

### [MINOR] GT1-FIND-012: Architecture Document Self-Reference Error

**File:** `spec/architecture.md` Lines 8-10
**Evidence:** "Genesis parameters and numeric constants are defined ONLY in: - Time domain is defined in: spec/time_domain.md (binding). - spec/genesis.md (canonical)."

The sentence structure is malformed. Line 8 starts a list for genesis parameters but line 9 inserts a time domain reference mid-sentence, creating syntactic ambiguity.

---

## Section 3: Missing Edge Cases in Failure Containment

### [MAJOR] GT1-FIND-013: Oracle Recovery Criteria Undefined

**File:** `spec/verification_checklist.md` Section 3.2
**Evidence:** "Oracle recovery ⇒ resume without discontinuity"

The spec mandates recovery behavior but does not define:
- What criteria determine oracle has recovered
- Whether recovery is automatic or requires intervention
- How to handle partial recovery (one feed valid, another stale)

---

### [MAJOR] GT1-FIND-014: Concurrent Failure Scenarios Not Addressed

**File:** `spec/security.md` Sections 3, 5
**Evidence:** Individual failure handling for oracle, gas, and asset suspension

The spec defines containment for each failure type in isolation but does not address:
- Oracle failure + gas depletion simultaneously
- Oracle failure + stablecoin suspension simultaneously
- Multiple stablecoins suspended simultaneously
- All three failure modes concurrent

---

### [MAJOR] GT1-FIND-015: ETH Rail + Oracle Failure Interaction Undefined

**File:** `spec/operations.md` Section 3.3, `spec/security.md` Section 3.1
**Evidence:** "ETH payments are valued in USD-equivalent using an ETH/USD oracle" / "oracle failure triggers pause + mint redirection"

When ETH/USD oracle fails:
- Does the ETH rail pause?
- Does the enable/disable gate still function?
- Is GasReserve routing affected?

The interaction between ETH rail and oracle failure containment is not specified.

---

### [MAJOR] GT1-FIND-016: Bootstrap Phase Behavior Undefined

**File:** `spec/genesis.md` Section 7
**Evidence:** "Initial activation requires a minimum inflow of ≥1,000 USD-equivalent"

The spec does not define:
- Protocol behavior between T0 and bootstrap threshold
- Whether minting occurs during bootstrap
- Whether Time Capital exists pre-bootstrap
- State of invariants pre-activation

---

### [MINOR] GT1-FIND-017: Asset Restoration Post-Segregation Undefined

**File:** `spec/contract_map_v2.md` Section 3.4
**Evidence:** "`restoreAsset(asset)` (if permitted)"

The phrase "if permitted" indicates uncertainty about whether asset restoration is allowed. The spec does not define:
- Criteria for restoration eligibility
- Whether restoration is reversible
- Impact on segregation levels

---

## Section 4: External Dependencies and Assumptions

### [MAJOR] GT1-FIND-018: ETH/USD Oracle Implementation Deferred

**File:** `spec/contract_map_v2.md` Section 3.3
**Evidence:** "validate oracle freshness / answer sanity (implementation-defined)"

Oracle validation criteria are explicitly deferred to implementation, creating a gap between specification authority and actual behavior. Freshness and sanity checks are safety-critical but undefined.

---

### [MAJOR] GT1-FIND-019: GUCT Quantity Calculation Undefined for ETH Purchases

**File:** `spec/operations.md` Section 5.3
**Evidence:** "The amount of GUCT delivered to the buyer is computed ONLY from the ETH retained"

The computation is mandated but not specified:
- Formula for converting retained ETH to GUCT quantity q
- Role of ETH/USD oracle in this calculation
- Interaction with P_next_min and premium cap

---

### [MINOR] GT1-FIND-020: Population Update Mechanism Underspecified

**File:** `spec/genesis.md` Section 5
**Evidence:** "adjustment to population assumptions MUST: be performed via DAO multisig"

The spec references DAO multisig authority but:
- DAO is listed as a non-goal in architecture
- No governance mechanism is defined
- Multisig structure is not specified

This creates a dependency on undefined external authority.

---

## Section 5: Verification Gap Analysis

### [MAJOR] GT1-FIND-021: Verification Matrix References Undefined Test IDs

**File:** `spec/verification_matrix.md` Header "VM-4"
**Evidence:** "UI/AI & Inheritance (VM-4)"

The matrix uses section identifier "VM-4" but earlier sections use alphabetic identifiers (A, B, C, D, E, F). The numbering scheme is inconsistent.

---

### [MINOR] GT1-FIND-022: Verification Checklist Section Numbering Gap

**File:** `spec/verification_checklist.md` Section 2
**Evidence:** Section headers: 2.X, 2.1, 2.2, 2.3, 2.4

Section 2.X appears before 2.1, creating non-standard ordering. The "X" designation purpose is unclear.

---

## Summary

| Severity | Count |
|----------|-------|
| CRITICAL | 5 |
| MAJOR | 14 |
| MINOR | 5 |
| **Total** | **24** |

### Critical Findings Summary

1. **GT1-FIND-001:** Grand Time unit undefined — all temporal canonicality unenforceable
2. **GT1-FIND-002:** CR/SR invariants undefined — core invariant unverifiable
3. **GT1-FIND-003:** 333-day stability standard undefined — non-negotiable rule unspecified
4. **GT1-FIND-004:** P_next_min calculation undefined — hard safety gate unimplementable
5. **GT1-FIND-005:** 111-day constraint undefined — bonding rule unspecified

---

*End of Report*
