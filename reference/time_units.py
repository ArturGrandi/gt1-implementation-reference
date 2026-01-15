"""
GT 1.0 — Canonical Time Units (Executable Reference)

Authoritative source:
- docs/CANONICAL_UNITS.md

Status:
- clarification-only
- no economic redesign
- no protocol behavior encoded
"""

# Canonical unit symbol
GRAND_SYMBOL = "G"

# Canonical daily mint (fixed)
GRAND_PER_DAY = 10_000_000


def is_valid_grand(value: int) -> bool:
    """
    A Grand is indivisible.
    No fractional values are permitted.
    """
    return isinstance(value, int) and value >= 0
