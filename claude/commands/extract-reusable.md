# Command: /extract-reusable

## Description
Scans code for reusable patterns and extracts them to the Lupio OS template library.

## Required Context
- User provides: directory to scan (defaults to `src/`)
- Reads: source files in the specified directory

## Agents Involved
- `refactor-librarian` — primary

## Execution Steps
1. Scan directory tree
2. Identify repeated patterns (threshold: 2+ occurrences)
3. Present candidates to user
4. For approved candidates: extract to `.lupio/templates/`
5. Document the extracted pattern
6. Optionally update source to use the template

## Expected Output
`.lupio/memory/reusable-candidates.md`
Extracted templates in `.lupio/templates/`

## File Outputs
`.lupio/memory/reusable-candidates.md`
`.lupio/templates/<type>/<name>/`
