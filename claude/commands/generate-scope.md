# Command: /generate-scope

## Description
Transforms a product brief or user description into a structured scope document.

## Required Context
- User provides: raw brief, requirements, or conversational description
- Reads: nothing (starts fresh or updates existing scope.md)

## Agents Involved
- `product-discovery` — primary
- `pm-controller` — records scope as baseline

## Execution Steps
1. Collect brief from user (ask if not provided)
2. Run `product-discovery` with brief
3. Present scope.md to user for review
4. Iterate based on feedback
5. Lock scope with `pm-controller` once approved

## Expected Output
`.lupio/memory/scope.md` with:
- Problem statement
- User personas
- MVP use cases
- Future phases
- Non-functional requirements
- Assumptions and open questions

## File Outputs
`.lupio/memory/scope.md`
