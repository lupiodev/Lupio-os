---
description: "Review UX flows, wireframes, or prototypes."
---

# /review-ux

Review UX flows, wireframes, or prototypes.

**Agent:** subagente `lupio-os:ux-reviewer`
**Inputs** (infiere del contexto y del código; pregunta solo lo que falte y no se pueda inferir, todo en un mensaje y con tu default recomendado): flow reference (Figma/Lovable/description), user personas
**Output:** `memory/ux-review.md` with prioritized issues (BLOCKER/MAJOR/MINOR)

**Token:** Load persona context only. No source code.
