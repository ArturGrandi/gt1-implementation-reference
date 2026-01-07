# GT 1.0 — Inheritance Model (v1.0, Binding)

Status: Binding (simplified v1.0 inheritance)

---

## 1) Opt-in Only

Inheritance is OPTIONAL and defined explicitly by the user.

The protocol MUST NOT assume heirs or default inheritance behavior.

---

## 2) Inactivity Period

inactivityPeriod = 222 days

Inactivity is defined as absence of user-signed actions.

---

## 3) Execution Rules

If heirs are defined:
- assets transfer according to user-defined rules
- only after inactivityPeriod elapses

If no heirs are defined:
- NO automatic transfer occurs
- NO confiscation
- NO redirection to Time Capital

---

## 4) Explicit Consent Requirement

The protocol MUST NOT move GUCT to Time Capital
without explicit prior user approval.

---

## 5) Non-Goals

- forced recovery
- custodial assumptions
- state intervention without consent
  
---

## Verification & References

Acceptance criteria and verification mapping:
- spec/verification_checklist.md (UI/AI & Inheritance section)
- spec/verification_matrix.md (VM-4: INH-1, INH-2, TC-LOCK-1)

Related:
- spec/security.md (non-confiscation and containment properties)
