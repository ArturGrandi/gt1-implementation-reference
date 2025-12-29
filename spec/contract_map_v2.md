# GT 1.0 — Contract Map v2 (Controlled Reference Implementation)

Status: Binding (implementation planning)

This document defines the contract/module breakdown for implementing GT 1.0
strictly according to `/spec`.

No economic redesign is permitted.
Genesis constants are defined ONLY in `spec/genesis.md` and must not be duplicated.

---

## 1) Implementation goals

- Provide a controlled reference implementation suitable for:
  - simulation,
  - verification,
  - invariant testing,
  - audit-style review.

- Provide observability surfaces required by:
  - `spec/security.md`
  - `spec/verification_checklist.md`

---

## 2) Recommended stack (security-oriented)

- Solidity ^0.8.x
- Foundry for unit + invariant + fuzz testing
- OpenZeppelin for access control, upgrade patterns (if used), and safe utils

Non-goals:
- deployment tooling, production infra, or token distribution UX.

---

## 3) Module overview (contracts)

### 3.1 `GT1Registry` (addresses + config wiring)
Responsibilities:
- stores addresses of core modules (Funds, OracleAdapter, Rails, Controller),
- enforces immutability or controlled updates (owner/multisig only),
- exposes read-only getters for all module addresses.

Must expose:
- `getModule(bytes32 key) -> address`
- events on module updates (if allowed)

Notes:
- keep minimal; avoid embedding constants.

---

### 3.2 `GT1AccessController` (roles, admin, multisig integration)
Responsibilities:
- role definitions for:
  - admin ops,
  - emergency segregation ops,
  - oracle admin (if needed),
  - registry admin.
- no governance token logic.

Must expose:
- role checks (OZ AccessControl or minimal custom)
- explicit role constants (names only)

---

### 3.3 `GT1OracleAdapter` (reference valuation only)
Responsibilities:
- validate oracle freshness / answer sanity (implementation-defined),
- expose normalized reference values:
  - ETH/USD (for ETH rail settlement),
  - stable USD-equivalent (if needed),
- expose oracle status:
  - valid / stale / inconsistent.

Must expose (read-only):
- `ethUsd() -> (uint256 price, bool valid)`
- `oracleStatus() -> (uint8 statusCode)` or equivalent
- event on status changes (recommended)

Hard constraints:
- no sell-offs, no liquidation triggers.

---

### 3.4 `GT1FundsLedger` (USD-equivalent accounting + segregation)
Responsibilities:
- maintain internal USD-equivalent accounting for:
  - System Fund,
  - Liquidity Fund,
  - Stability Fund,
  - Time Capital,
- enforce Emergency Asset Segregation (Level 1 + Level 2):
  - excluded assets do not enter CR/SR calculations when frozen/oracle-failed,
  - segregation does not change price or mint logic.

Must expose (read-only):
- per-fund balances in USD accounting
- eligible asset set for coverage
- segregation state per asset

Must expose (write, restricted):
- `segregateAssetLevel1(asset)`
- `segregateAssetLevel2(asset)`
- `restoreAsset(asset)` (if permitted)

Events:
- `AssetSegregated(asset, level)`
- `AssetRestored(asset)`

---

### 3.5 `GT1MintEngine` (daily mint + mint-gates)
Responsibilities:
- enforce daily mint amount `M` as defined in `spec/genesis.md` (passed via init param),
- apply mint coverage gate and valuation pause behavior:
  - if coverage insufficient OR oracle invalid => valuation issuance pauses,
  - daily mint redirected to Time Capital.
- enforce: price does not decrease due to gate.

Must expose:
- `isValuationPaused() -> bool`
- `mintDestination() -> enum {Normal, TimeCapital}`
- `lastMintTimestamp() -> uint256` (or equivalent)
- event when pause toggles / destination changes

Notes:
- no hardcoded constants; consume params via init and read from registry.

---

### 3.6 `GT1PriceController` (reference price & P_next_min surfaces)
Responsibilities:
- compute/track:
  - current reference price `P`,
  - predicted next minimum price `P_next_min` (as defined by spec logic),
- enforce bonding premium cap (44%) and small purchase rule (<= 111 daily shares => P_next_min).
- provide pricing quotes used by rails.

Must expose (read-only):
- `price() -> uint256`
- `pNextMin() -> uint256`
- `quoteBuy(amount) -> (uint256 price, uint256 premiumBps, ...)`
- `premiumCapBps() -> uint256` (value comes from spec; may be constant in code IF not a genesis constant)

Hard constraints:
- no reflexive price collapse.

---

### 3.7 `GT1TimeCapitalVault` (aggregated vault/time-safe)
Responsibilities:
- hold unverified accrual as aggregated balance (not per-user),
- support claimability once verified (via claim module),
- enforce: verification is access control, not higher mining.

Must expose:
- `unverifiedAccruedTotal() -> uint256`
- `claimableOf(account) -> uint256` (if tracked)
- `claim(account)` (restricted by verification logic)

Events:
- `Accrued(amount, destination)`
- `Claimed(account, amount)`

---

### 3.8 `GT1VerificationRegistry` (identity gating, not multiplier)
Responsibilities:
- track verification status of accounts,
- provide access gates for:
  - claiming,
  - holding/transferring (if required by controlled implementation),
  - redeem/usage flows.

Must expose:
- `isVerified(account) -> bool`
- events: `Verified(account)` / `Revoked(account)` (if revocation allowed)

Note:
- specifics of verification mechanism may be off-chain; on-chain module enforces status only.

---

### 3.9 `GT1StableRail` (stablecoin-agnostic deposit/redeem, 0% fees)
Responsibilities:
- accept supported stablecoins (USDT/USDC/DAI),
- perform deposit/redeem with 0% protocol fees (gas only),
- interact with FundsLedger for USD accounting,
- respect asset suspension/segregation rules.

Must expose:
- `deposit(asset, amount, ...)`
- `redeem(asset, amount, ...)`

Hard constraints:
- must revert if asset suspended/segregated for that operation.

Events:
- `Deposited(asset, amount, usdValue)`
- `Redeemed(asset, amount, usdValue)`

---

### 3.10 `GT1EthTimeCapitalRail` (ETH/WETH buy-from-Time-Capital)
Responsibilities:
- implement `buyFromTimeCapitalWithETH()` (or equivalent),
- enforce enable/disable rule:
  - enabled only when GasReserve < target threshold (from genesis),
  - disabled/revert when GasReserve >= target threshold,
- use ETH/USD oracle for USD-equivalent valuation,
- enforce System Fund coverage gate:
  - move ΔF_liq_USD = q * P from System Fund to Liquidity Fund (USD accounting),
  - revert unless System Fund remains >= required floor for P_next_min,
- route retained ETH to GasReserve up to target,
- refund excess ETH in same tx,
- compute delivered GUCT only from retained ETH.

Must expose (read-only):
- `ethRailEnabled() -> bool` (derived)
- `gasReserveBalance() -> uint256` (or via GasReserve module)
- events: `EthRetained(amount)`, `EthRefunded(amount)`, `EthPurchase(q, retainedEth, refundedEth)`

---

### 3.11 `GT1GasReserve` (ops ETH/WETH)
Responsibilities:
- hold ETH/WETH for ops only,
- receive ETH from ETH rail up to target threshold,
- allow manual top-up (external transfer),
- expose balance.

Must expose:
- `balance() -> uint256`
- event on top-up / receive (recommended)

Hard constraints:
- does not subsidize user gas.

---

## 4) Required revert reasons (recommended)

Implementations SHOULD use explicit revert reasons or custom errors for:
- `RailDisabled()` (GasReserve >= target)
- `OracleInvalid()` (ETH/USD invalid or required oracle invalid)
- `InsufficientSystemFundForNextMin()` (coverage gate fails)
- `AssetSuspended(asset)` / `AssetSegregated(asset, level)`
- `ValuationPaused()` (if purchase depends on valuation issuance)
- `NotVerified()` (claim/usage rights)

---

## 5) Required observability surfaces (binding)

Contracts MUST expose enough views/events to satisfy:
- `spec/security.md`
- `spec/verification_checklist.md`

At minimum:
- GasReserve balance
- ETH rail enabled/disabled
- retained/refunded ETH per purchase
- System->Liquidity coverage move amount per ETH purchase (USD accounting)
- oracle status + valuation pause flag
- mint redirection destination

---

## 6) Implementation order (recommended)

1) Registry + AccessController
2) OracleAdapter (status + ETH/USD)
3) FundsLedger (+ segregation)
4) PriceController (P, P_next_min, quote surfaces)
5) MintEngine (pause + redirect)
6) TimeCapitalVault + VerificationRegistry (access gating)
7) StableRail (0% fees, asset-agnostic, suspension)
8) GasReserve + ETH TC Rail (enable/disable, refund, coverage gate)
9) Test suite (unit + invariant + fuzz) mapped to verification_checklist.md

---

## 7) References

- spec/genesis.md
- spec/architecture.md
- spec/operations.md
- spec/security.md
- spec/verification_checklist.md
