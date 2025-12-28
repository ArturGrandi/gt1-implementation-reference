# GT 1.0 — Security Model (Binding)

Status: Binding (implementation scope)

This document defines mandatory security invariants, pause/revert rules,
and required stress cases for GT 1.0.

All numeric deployment parameters and thresholds are defined ONLY in:
- spec/genesis.md (canonical)

This file MUST NOT duplicate genesis constants.

---

## 1) Security Scope

GT 1.0 security focuses on preserving:
- invariants (CR/SR, stability standard, mint-gates),
- non-reflexive price logic (no cascade behavior),
- containment under oracle and asset failures,
- correctness of GasReserve / ETH rail behavior,
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
3) No reflexive mint adjustments triggered by price/oracle noise.
4) Deposit/redeem protocol fees remain 0% (gas only).
5) Multi-Asset Liquidity + Emergency Asset Segregation (Level 1 + Level 2) is mandatory.
6) Stablecoin-agnostic behavior (USDT/USDC/DAI): suspension must not affect price logic.
7) Genesis constants must not be duplicated outside spec/genesis.md.

---

## 3) Pause & Containment Policy (Binding)

### 3.1 Oracle-gated valuation issuance
Oracles provide reference valuation only.

They do NOT:
- define economic meaning,
- trigger automatic sell-offs,
- enforce liquidation logic.

Oracle failure handling (binding):
If oracle becomes stale/invalid/inconsistent:
- valuation issuance is paused,
- mint is redirected to Time Capital,
- protocol reference price remains unchanged.

No oracle failure may trigger:
- forced asset conversion,
- price collapse,
- reflexive mint adjustments.

### 3.2 Asset suspension (stablecoin-agnostic)
If any supported stablecoin is suspended (blacklist risk / depeg / halted transfers):
- new operations using that asset MUST revert or be paused for that asset only,
- other assets and rails continue if safe,
- internal price logic and invariants MUST remain unchanged.

Suspension is an availability constraint, not an economic event.

### 3.3 GasReserve depletion (ops continuity only)
GasReserve affects protocol operational continuity only.

If GasReserve is low/depleted:
- ops execution may be delayed,
- NO economic meaning changes,
- NO price logic changes,
- NO mint logic changes except those already defined under oracle failure pause.

Manual top-up restores ops capability.

---

## 4) ETH Rail (Time Capital Only) — Mandatory Safety Gates

### 4.1 Enable/disable gate (GasReserve)
ETH TC rail is enabled only when:
GasReserve < targetGas (defined in spec/genesis.md)

If GasReserve >= targetGas:
- ETH rail MUST revert.

### 4.2 System Fund coverage gate (P_next_min preservation)
On ETH-based purchase of q GUCT at internal price P:

The protocol MUST move USD-equivalent coverage from System Fund to Liquidity Fund:
ΔF_liq_USD = q * P

Funding source is System Fund (USD accounting), NOT incoming ETH.

ETH purchase MUST revert unless:
F_sys_USD - (q * P) >= F_sys_req_USD(P_next_min)

This is a hard safety gate.

### 4.3 Refund correctness (v1)
If msg.value exceeds the amount needed to reach targetGas:
- excess ETH MUST be refunded in the same transaction.

GUCT delivered MUST be computed only from retained ETH.

---

## 5) Required Stress Cases (Acceptance Criteria)

The controlled implementation MUST include tests (unit/invariant/fuzz where applicable)
covering at least the following scenarios.

### 5.1 Oracle failure scenarios
- stale oracle timestamp -> valuation issuance paused; mint redirected to Time Capital.
- inconsistent oracle values across feeds -> paused; no sell-offs.
- oracle returns zero/negative/out-of-range -> paused; no economic changes.
- oracle recovers -> issuance resumes without price discontinuity.

### 5.2 GasReserve / ETH rail scenarios
- GasReserve < targetGas -> ETH rail enabled (subject to other gates).
- GasReserve >= targetGas -> ETH rail reverts.
- GasReserve below minGas -> no auto-buy requirement; manual top-up path exists.
- refund path correctness:
  - retained ETH increases GasReserve up to target,
  - excess refunded in same tx,
  - delivered GUCT matches retained ETH only.

### 5.3 System Fund coverage gate scenarios
- ETH purchase where System Fund coverage is sufficient -> succeeds and transfers q*P coverage.
- ETH purchase where coverage would violate P_next_min -> reverts.
- verify ΔF_liq_USD accounting matches q*P exactly (no rounding drift that weakens gates).

### 5.4 Stablecoin suspension scenarios
- suspend USDT -> USDT operations revert/paused; USDC/DAI remain functional.
- suspend USDC -> USDC operations revert/paused; others functional.
- verify price logic unchanged by suspension event.

### 5.5 Emergency Asset Segregation scenarios
- Level 1 segregation isolates designated assets without affecting price logic.
- Level 2 segregation isolates high-risk assets; protocol continues with safe assets.
- ensure segregation cannot be abused to bypass mint-gates or coverage rules.

---

## 6) Non-Goals (Explicit)

- No “profit protection” mechanisms.
- No liquidation engine.
- No price stabilization via market ops beyond what the spec defines.
- No user gas subsidy.

---

## 7) References

- spec/genesis.md — canonical parameters (only source of constants)
- spec/architecture.md — module boundaries and mandatory gates
- spec/operations.md — runtime rail rules, routing, pauses
