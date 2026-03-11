# Command: /review-ux

## Description
Reviews UX flows, wireframes, or prototypes and produces a prioritized improvement list.

## Required Context
- User provides: Lovable URL, Figma URL, or flow description
- Reads: `.lupio/memory/scope.md` for persona context

## Agents Involved
- `ux-reviewer` — primary

## Execution Steps
1. Collect the flow reference from user
2. Read persona definitions from scope.md
3. Run `ux-reviewer`
4. Present findings grouped by priority
5. Ask user which issues to address now vs. later

## Expected Output
`.lupio/memory/ux-review.md` with prioritized issues

## File Outputs
`.lupio/memory/ux-review.md`
