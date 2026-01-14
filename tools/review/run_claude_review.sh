#!/usr/bin/env bash
set -euo pipefail

# Strict AI-assisted technical review runner
# Prompt source: docs/AI_REVIEW_QUESTIONNAIRE.md ONLY
# Tools restricted to read-only

STAMP="$(date +%Y%m%d-%H%M%S)"
OUT="out/review/claude_findings_${STAMP}.txt"

claude -p \
  --system-prompt-file docs/AI_REVIEW_QUESTIONNAIRE.md \
  --tools "Read,Grep,Glob" \
  --max-turns 12 \
  --output-format text \
  " " | tee "${OUT}"

echo ""
echo "Review saved to: ${OUT}"
