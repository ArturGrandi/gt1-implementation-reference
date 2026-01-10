# GT 1.0 — Architecture (Controlled Reference Implementation)

Status: Binding (implementation scope)

This document defines the module boundaries and interaction contracts
for the GT 1.0 controlled reference implementation.

Genesis parameters and numeric constants are defined ONLY in:
- Time domain is defined in: spec/time_domain.md (binding).
- spec/genesis.md (canonical).

Other documents may reference genesis values but MUST NOT duplicate them.
  
---

## Visual Architecture Overview

The high-level system structure and module boundaries are illustrated in the following diagram:

- [`architecture-overview.svg`](../docs/diagrams/architecture-overview.svg)

The diagram is conceptual only:
- no numeric parameters,
- no tokenomics,
- no formulas.

It defines system boundaries, on-chain vs off-chain separation, and mandatory control paths.

## 1) Purpose & Scope

GT 1.0 is an implementation-first economic protocol.
This repository is a controlled reference implementation for research, simulation, and verification.

Non-goals:
- production deployment,
- commercial operation,
- economic redesign discussions.
- All temporal references inside the protocol are expressed in Grand Time units.
- Block time or wall-clock time is treated as an external transport signal only.

---

## 2) Layering Model

### 2.1 Spec layer (binding)
- spec/genesis.md — canonical initialization and deployment parameters
- spec/operations.md — runtime operational rules (rails, pauses, routing)
- spec/security.md — invariants and stress cases
- spec/architecture.md — module map and boundaries (this file)

### 2.2 Implementation layer (controlled)
- contracts/ — smart contracts implementing the binding spec
- interfaces/ — interface definitions (ABI / UI bindings)
- docs/ — developer notes and verification artifacts (non-binding)

---

## 3) Canonical Modules (On-chain)

### 3.1 Core Accounting & State
Responsibilities:
- maintains protocol state variables and accounting ledgers,
- enforces mint-gates and invariants (CR/SR, stability standard),
- exposes read-only views for verification.

Constraints:
- must not embed external constants except via genesis parameters,
- must not include any forced conversion/liquidation logic.

### 3.2 Funds & Ledgers (USD-equivalent accounting)
Logical sub-ledgers (implementation may vary):
- System Fund (USD accounting)
- Liquidity Fund (USD accounting)
- Time Capital (protocol-native accounting)
- Emergency Asset Segregation (Level 1 + Level 2) — mandatory

Responsibilities:
- maintain balances and internal transfers,
- enforce fund-gates required by P_next_min,
- isolate emergency assets without affecting price logic.

### 3.3 Mint Engine
Responsibilities:
- computes daily mint M (defined in spec/genesis.md),
- applies mint allocation rules and mint-gates,
- redirects mint to Time Capital when valuation issuance is paused.

Constraints:
- does not introduce fees,
- does not react reflexively to oracle noise.
- Accrual semantics are uniform across all humans (1:1).
- Verification affects access and ownership only, not accrual rates.

### 3.4 Valuation Issuance (Oracle-gated)
Responsibilities:
- consumes oracle reference valuations to issue valuation outputs,
- can be paused when oracle invalid/stale/inconsistent.

Constraints:
- oracle provides reference valuation only,
- oracle failure triggers pause + mint redirection, not sell-offs.

See: spec/security.md (Oracle failure handling).

### 3.5 Oracle Adapter Layer
Responsibilities:
- validates oracle freshness / consistency,
- normalizes price feeds (e.g., ETH/USD),
- provides reference valuations only.

Constraints:
- MUST NOT define economic meaning,
- MUST NOT trigger liquidation or forced conversions.

### 3.6 Time Capital Purchase Rails
Two settlement rails may exist in the controlled reference implementation:
- Stablecoin rail (stablecoin-agnostic: USDT/USDC/DAI)
- ETH rail (Time Capital only), conditionally enabled by GasReserve state

Constraints:
- deposit/redeem protocol fees are 0% (gas only),
- no “social transaction” gas subsidy.

### 3.7 GasReserve (ETH/WETH) — Ops Infrastructure
Responsibilities:
- holds ETH/WETH for protocol operational transactions only,
- supports gas autonomy for protocol ops transactions (not user transactions).

Hard constraints:
- protocol does NOT subsidize user transactions,
- minimum-threshold replenishment (as defined in spec/genesis.md) is manual admin transfer (external ETH),
- ETH rail is enabled only when GasReserve < targetGas.

All thresholds are defined in spec/genesis.md.

---

## 4) ETH Rail — Mandatory Safety Gates (Architecture Contract)

### 4.1 Enable/disable gate (GasReserve)
ETH TC rail is enabled only when:
GasReserve < targetGas

If:
GasReserve >= targetGas
then:
ETH TC rail MUST revert.

### 4.2 System Fund coverage gate (P_next_min preservation)
On ETH-based purchase of q GUCT at internal price P:

The protocol MUST move USD-equivalent coverage from System Fund to Liquidity Fund:
ΔF_liq_USD = q * P

This is funded by System Fund (USD accounting), NOT by incoming ETH.

ETH purchase MUST revert unless:
F_sys_USD - (q * P) >= F_sys_req_USD(P_next_min)

This gate is mandatory to preserve the predicted next minimum price logic.

### 4.3 ETH routing & refund rule (v1)
ETH is routed to GasReserve up to targetGas.
Any ETH in excess of reaching targetGas MUST be refunded in the same transaction.

Delivered GUCT is computed ONLY from retained ETH.
Refunded ETH buys 0 GUCT (no implicit settlement).

---

## 5) Failure Modes & Containment

### 5.1 Oracle failure
- valuation issuance paused,
- mint redirected to Time Capital,
- protocol reference price unchanged.

No forced conversions. No sell-offs.

### 5.2 GasReserve depletion
GasReserve depletion affects ops continuity only.
It must not change economic meaning, price logic, or invariants.

Manual top-up restores ops capability.

### 5.3 Asset suspension (stablecoin-agnostic)
Supported stablecoins may be suspended without affecting:
- internal price logic,
- invariants,
- other rails.

Suspension is handled as an availability constraint, not an economic event.

---

## 6) References (Binding Links)

- spec/genesis.md — canonical deployment parameters (only source of constants)
- spec/operations.md — runtime rules for rails, pauses, routing
- spec/security.md — mandatory invariants, pause/revert policy, required stress cases
- spec/ui_ai_model.md — AI & UI interaction constraints
- spec/inheritance.md — opt-in inheritance model (v1.0)
