# Command: /update-knowledge

## Description
Applies accumulated lessons to update Lupio OS agent definitions, templates, and checklists.

## Required Context
- Reads: `.lupio/memory/prompt-changelog.md`
- Reads: `.lupio/memory/reusable-candidates.md`

## Agents Involved
- `learning-agent` — primary

## Execution Steps
1. Read prompt-changelog.md
2. For each pending improvement: apply to the relevant agent .md file
3. Read reusable-candidates.md
4. For each approved candidate: update `.lupio/templates/`
5. Mark applied changes in changelog

## Expected Output
Updated agent files and templates

## File Outputs
`.lupio/agents/<name>.md` (updated)
`.lupio/templates/<type>/` (updated)
`.lupio/memory/prompt-changelog.md` (marked applied)
