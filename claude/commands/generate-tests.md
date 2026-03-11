# Command: /generate-tests

## Description
Creates a comprehensive test suite for a module or feature.

## Required Context
- User provides: module/feature path
- Reads: source files for the module, acceptance criteria if available

## Agents Involved
- `qa-lead` — primary

## Execution Steps
1. Read module source files
2. Extract exported functions, endpoints, and components
3. Generate unit tests for each function
4. Generate integration tests for API endpoints
5. Generate E2E test scenarios for user flows (using Playwright if available)
6. Write QA report

## Expected Output
- Unit test file for each source file
- Integration test for API module
- E2E spec for user-facing features
- `.lupio/memory/qa-report.md` (updated)

## File Outputs
`tests/` directory
`.lupio/memory/qa-report.md`
