---
description: "Scan code for reusable patterns and extract to template library."
---

# /extract-reusable <path>

Scan code for reusable patterns and extract to template library.

**Agent:** subagente `lupio-os:refactor-librarian`
**Ask:** directory to scan
**Threshold:** 2+ occurrences to flag
**Outputs:** `memory/reusable-candidates.md`, `templates/<type>/<name>/`

**Token:** Scan file names first. Load file contents only for flagged patterns.
