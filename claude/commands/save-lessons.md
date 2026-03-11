# Command: /save-lessons

## Description
Records lessons learned from a completed phase and stores them in project memory.

## Required Context
- User provides: phase name, what worked, what didn't, key decisions
- Reads: `.lupio/memory/` files for the current phase

## Agents Involved
- `learning-agent` — primary

## Execution Steps
1. Ask user for phase summary or accept raw notes
2. Structured prompt to extract: wins, failures, surprises, improvements
3. Write postmortem file
4. Update prompt-changelog.md if any agent prompts should change
5. Add reusable candidates if any patterns emerged

## Expected Output
`.lupio/memory/postmortem-YYYY-MM-DD.md`
`.lupio/memory/prompt-changelog.md` (updated)

## File Outputs
`.lupio/memory/postmortem-YYYY-MM-DD.md`
`.lupio/memory/prompt-changelog.md`
