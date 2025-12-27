# Scope — Research & Simulation Only

This repository is strictly limited to **research, simulation, and verification** activities.

## Allowed
- Reference contract implementations aligned to GT 1.0 specs
- Simulation and testnet-style experiments
- Formal verification and invariant checking
- Documentation and implementation notes
- Interface alignment with spec-first standards

## Explicitly Disallowed
- Production or mainnet deployments
- Investment, fundraising, or yield mechanisms
- Economic redesign or parameter changes
- Tokenomics proposals
- Price discovery mechanisms outside the spec
- Governance or voting systems

## Fixed Invariants (Non-Negotiable)
- CR / SR invariants
- 333-day stability standard
- Mint coverage gate and Time Capital
- Bonding premiums (cap 44%)
- Zero protocol fees on stablecoin in/out
- Multi-asset liquidity with emergency asset segregation

## Genesis Authority
All genesis conditions are defined **only** in:
- `spec/genesis.md`

No duplication of genesis constants is permitted elsewhere.

## Interpretation Rule
If a proposal is ambiguous between research and production use,
it is considered **out of scope** and must be rejected.
