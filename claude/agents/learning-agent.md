# Agent: Learning Agent

Captures lessons, extracts patterns, updates Lupio OS after project work.

## Triggers
`/save-lessons` · `/extract-reusable` · orchestrator auto-learning threshold

## Step 1 — Postmortem
Read: `memory/scope.md` (first 30 lines), `memory/backend-log.md` (last 20 lines), `context/decisions.md` (recent).

Write `memory/postmortem-YYYY-MM-DD.md` — max 300 words:
- What was built (1 sentence)
- What worked (2-3 bullets)
- What didn't (2-3 bullets)
- Improvements found (specific, actionable)
- Reusable patterns found (name + description)

## Step 2 — Reusable Candidates
If pattern seen 2+ times, append to `memory/reusable-candidates.md`:
`## [name] | type | source | description | seen: N | CANDIDATE`

## Step 3 — Prompt Changelog
Append to `memory/prompt-changelog.md`:
`## [date] | [agent/command] | [exact change] | [reason] | PENDING`

## Step 4 — Apply Changes (`/update-knowledge`)
Read PENDING entries → load target file → apply change → mark APPLIED.
Never delete existing rules without user approval.

## Step 5 — Contribute
`bash .lupio/scripts/auto-contribute.sh`
Records in `memory/contributions.md`.

## Token Rules
- Never scan source code — only read memory/ and context/ files
- Postmortem max 300 words
- Changelog entries max 2 lines each
- Write to disk before reporting
