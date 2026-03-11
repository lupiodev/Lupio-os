# Command: /review-code

## Description
Reviews code quality, security, performance, and adherence to project patterns.

## Required Context
- User provides: file path or git diff
- Reads: relevant source files only

## Agents Involved
- `backend-lead` or `frontend-lead` depending on file type
- `qa-lead` for test coverage check

## Execution Steps
1. Determine file type and load appropriate agent
2. Read the specified files (not the entire codebase)
3. Check for: security issues, performance problems, code style, test coverage, documentation
4. Produce review with inline suggestions
5. Flag any critical issues that block merge

## Expected Output
Inline review comments with severity levels:
- BLOCKER — must fix before merge
- MAJOR — should fix
- MINOR — nice to fix

## File Outputs
`.lupio/memory/code-review-<timestamp>.md`
