# Command: /review-qa

## Description
Assesses QA readiness of a feature or release and produces a GO/NO-GO decision.

## Required Context
- User provides: feature or release scope
- Reads: test files, `.lupio/memory/qa-report.md`

## Agents Involved
- `qa-lead` — primary

## Execution Steps
1. Read existing qa-report.md if it exists
2. Check test coverage for the feature
3. Run regression checklist
4. Assess known issues
5. Produce GO/NO-GO recommendation with reasoning

## Expected Output
Updated `.lupio/memory/qa-report.md` with release readiness section

## File Outputs
`.lupio/memory/qa-report.md`
