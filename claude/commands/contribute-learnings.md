# Command: /contribute-learnings

## Description
Packages lessons learned from this project and opens an automatic Pull Request
against the central Lupio OS repository so improvements propagate to all future projects.

## Required Context
- Requires `/save-lessons` to have been run first
- Reads: `.lupio/memory/prompt-changelog.md`
- Reads: `.lupio/memory/reusable-candidates.md`
- Reads: `.lupio/memory/postmortem-*.md`

## Agents Involved
- `learning-agent` — reviews and packages the learnings before submitting

## Execution Steps
1. Read `prompt-changelog.md` and summarize proposed prompt changes
2. Read `reusable-candidates.md` and confirm patterns are generic enough
3. Strip any project-specific data (names, secrets, business logic)
4. Run `scripts/contribute.sh` to open the PR automatically
5. Report the PR URL to the user

## Expected Output
A Pull Request opened at: https://github.com/lupiodev/Lupio-os

## File Outputs
`learnings/<date>-<project>/` inside the lupio-os repo (via PR)

## Notes
- The learning-agent must generalize all patterns before submitting
- Never include real data, credentials, or proprietary business logic
- The PR must be reviewed and merged manually before it propagates
