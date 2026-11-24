---
description: "Scan code for reusable patterns and extract to template library."
---

# /extract-reusable <path>

Scan code for reusable patterns and extract to template library.

**Agent:** subagente `lupio-os:refactor-librarian`
**Inputs** (infiere del contexto y del código; pregunta solo lo que falte y no se pueda inferir, todo en un mensaje y con tu default recomendado): directory to scan
**Threshold:** 2+ occurrences to flag
**Outputs:** `memory/reusable-candidates.md`, `templates/<type>/<name>/`

**Token:** Scan file names first. Load file contents only for flagged patterns.
