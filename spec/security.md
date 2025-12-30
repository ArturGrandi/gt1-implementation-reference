# GT 1.0 — Security Model (Binding)

Status: Binding (implementation scope)

This document defines mandatory security invariants, containment rules,
and required stress cases for GT 1.0.

All numeric deployment parameters and thresholds are defined ONLY in:
- spec/genesis.md (canonical)

This file MUST NOT duplicate genesis constants.

All time-based security invariants are evaluated exclusively in the
Grand Time domain as defined in:
- spec/time_domain.md (binding)

---

## 1) Security Scope

GT 1.0 security focuses on preserving:

- Grand Time–based invariants (independent of oracle timestamps or block time),
- core economic invariants (CR/SR, stability standard, mint-gates),
- non-reflexive price logic (no cascade or feedback behavior),
- containment under oracle, gas, and asset failures,
- correctness of GasReserve and ETH Time Capital rail behavior,
- correctness of fund coverage gates (P_next_min preservation).

Non-goals:
- production hardening guarantees,
- censorship resistance claims,
- MEV-proofing as a deliverable of this reference implementation.

---

## 2) Binding Invariants (Non-Negotiable)

The implementation MUST preserve:

1) No forced asset conversion or liquidation logic.
2) No oracle-driven sell-offs.
3) No reflexive mint adjustments triggered by price or oracle noise.
4) Deposit/redeem protocol fees remain 0% (gas only).
5) Multi-Asset Liquidity with Emergency Asset Segregation
   (Level 1 + Level 2) is mandatory.
6) Stablecoin-agnostic behavior (USDT / USDC / DAI):
   asset suspension MUST NOT affect price logic or invariants.
7) Genesis constants MUST NOT be duplicated outside spec/genesis.md.

---

## 3) Pause & Containment Policy (Binding)

All pauses defined below are **containment mechanisms**.
They MUST NOT alter economic meaning, pricing logic, or invariants.

### 3.1 Oracle-gated valuation issuance

Oracles provide reference valuation only.

They do NOT:
- define economic meaning,
- define time or epochs,
- trigger automatic sell-offs,
- enforce liquidation logic.

Oracle failure handling (binding):

If an oracle becomes stale, invalid, or inconsistent:
- valuation issuance is paused,
- mint is redirected to Time Capital,
- protocol reference price remains unchanged.

No oracle failure may trigger:
- forced asset conversion,
- price collapse,
- reflexive mint adjustments.

---

### 3.2 Asset suspension (stablecoin-agnostic)

If any supported stablecoin is suspended
(blacklist risk, depeg, halted transfers):

- new operations using that asset MUST revert or pause for that asset only,
- other assets and rails MAY continue if safe,
- internal price logic and all invariants MUST remain unchanged.

Asset suspension is an availability constraint,
not an economic event.

---

### 3.3 GasReserve depletion (ops continuity only)

GasReserve affects protocol operational continuity only.

If GasReserve is low or depleted:
- protocol ops execution may be delayed,
- NO economic meaning changes,
- NO price logic changes,
- NO mint logic changes except those already defined
  under oracle-gated pause rules.

Manual top-up restores ops capability.

---

## 4) ETH Rail (Time Capital Only) — Mandatory Safety Gates

### 4.1 Enable / disable gate (GasReserve)

The ETH Time Capital rail is enabled only when:
GasReserve < targetGas (defined in spec/genesis.md)

If:
GasReserve >= targetGas

Then:
- ETH rail MUST revert.

---

### 4.2 System Fund coverage gate (P_next_min preservation)

On ETH-based purchase of q GUCT at internal price P:

The protocol MUST move USD-equivalent coverage from
System Fund to Liquidity Fund:

ΔF_liq_USD = q * P

Funding source MUST be System Fund (USD accounting),
NOT incoming ETH.

ETH purchase MUST revert unless:

F_sys_USD - (q * P) >= F_sys_req_USD(P_next_min)

This is a hard safety gate.

---

### 4.3 Refund correctness (v1)

If msg.value exceeds the amount required to reach targetGas:
- excess ETH MUST be refunded in the same transaction.

GUCT delivered MUST be computed ONLY from retained ETH.

---

## 5) Required Stress Cases (Acceptance Criteria)

The controlled implementation MUST include tests
(unit, invariant, or fuzz where applicable)
covering at least the following scenarios.

### 5.1 Oracle failure scenarios

- stale oracle timestamp → issuance paused; mint redirected to Time Capital,
- inconsistent oracle feeds → paused; no sell-offs,
- zero / negative / out-of-range oracle values → paused; no economic changes,
- oracle recovery → issuance resumes without price discontinuity.

---

### 5.2 GasReserve / ETH rail scenarios

- GasReserve < targetGas → ETH rail enabled (subject to other gates),
- GasReserve ≥ targetGas → ETH rail reverts,
- GasReserve below minGas → no auto-buy requirement; manual top-up path exists,
- refund correctness:
  - retained ETH increases GasReserve up to target,
  - excess refunded in same transaction,
  - delivered GUCT matches retained ETH only.

---

### 5.3 System Fund coverage gate scenarios

- sufficient coverage → ETH purchase succeeds and transfers q * P,
- insufficient coverage → ETH purchase reverts,
- ΔF_liq_USD accounting matches q * P exactly
  (no rounding drift weakening gates).

---

### 5.4 Stablecoin suspension scenarios

- suspend USDT → USDT ops paused; USDC/DAI remain functional,
- suspend USDC → USDC ops paused; others functional,
- verify price logic unchanged by suspension events.

---

### 5.5 Emergency Asset Segregation scenarios

- Level 1 segregation isolates designated assets
  without affecting price logic,
- Level 2 segregation isolates high-risk assets;
  protocol continues with safe assets,
- segregation cannot bypass mint-gates or coverage rules.

---

## 6) Explicit Non-Goals

- No profit protection mechanisms.
- No liquidation engine.
- No price stabilization via discretionary market ops.
- No user gas subsidy.

---

## Acceptance Link (Binding)

All security-related acceptance criteria are consolidated in:
- spec/verification_checklist.md

Any implementation that does not satisfy the checklist
MUST be treated as non-acceptable,
even if it compiles or passes partial tests.

---

## 7) References

- spec/genesis.md — canonical parameters (only source of constants)
- spec/time_domain.md — canonical time domain definition
- spec/architecture.md — module boundaries and mandatory gates
- spec/operations.md — runtime rail rules, routing, pauses
