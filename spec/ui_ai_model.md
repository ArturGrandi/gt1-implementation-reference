# GT 1.0 — UI & AI Interaction Model (Binding)

Status: Binding (implementation scope)

This document defines the permitted role of AI-driven interfaces
(GT Protocol Chat, assistants, analytics UIs) in GT 1.0.

---

## 1) AI Role (Strictly Limited)

AI integrations (including GPT-based chat interfaces) MUST operate as:

- Read-only AI
- Guided Actions provider

AI MUST NOT:
- execute transactions,
- hold or derive private keys,
- sign messages,
- alter protocol state,
- bypass contract-level permissions.

---

## 2) Grounding & Source of Truth (Binding)

All AI responses MUST be grounded exclusively via RAG over:

- /spec/*.md
- Security appendices
- Glossary files

AI output MUST NOT rely on:
- implicit assumptions,
- unstated parameters,
- off-repo sources for protocol behavior.

---

## 3) Permitted Outputs

AI MAY provide:
- protocol education and explanations,
- UX guidance (how-to, step-by-step),
- analytics and charts (clearly labeled as informational),
- comparative analysis vs other systems (non-promotional).

All outputs MUST include clear disclaimers:
- "Informational only"
- "No execution authority"

---

## 4) Non-Goals

- AI-driven automation
- AI custodianship
- AI governance authority
