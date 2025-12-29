# Pull Request — GT 1.0 Controlled Reference Implementation

## Scope of this PR
- [ ] Bug fix
- [ ] Spec-aligned implementation
- [ ] Test / verification improvement
- [ ] Refactor (no behavior change)

---

## Spec alignment (mandatory)

This PR implements behavior defined in:
- [ ] spec/architecture.md
- [ ] spec/operations.md
- [ ] spec/security.md
- [ ] spec/verification_checklist.md
- [ ] spec/contract_map_v2.md

List exact spec sections referenced:
- 

---

## Genesis constants
- [ ] No genesis constants are hardcoded
- [ ] All parameters are injected or referenced via spec/genesis.md

---

## Invariants & safety
- [ ] CR / SR invariants preserved
- [ ] No oracle-driven sell-offs or liquidation logic introduced
- [ ] No protocol fees added
- [ ] No economic redesign

---

## Tests & verification
- [ ] Unit tests updated / added
- [ ] Invariant or fuzz tests added where applicable
- [ ] All relevant cases from spec/verification_checklist.md are covered

---

## Prohibited content (self-check)
This PR does NOT:
- propose new economic parameters,
- modify mint logic semantics,
- reinterpret oracle meaning,
- bypass pause or coverage gates,
- introduce governance or voting logic.

---

## Reviewer notes
Describe anything non-obvious for reviewers:
