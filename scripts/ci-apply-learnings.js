#!/usr/bin/env node
'use strict';

/**
 * CI script — runs on GitHub Actions after a learning PR is merged.
 * Reads learnings/ folder and applies safe, generic improvements
 * to agent prompts and templates.
 */

const fs = require('fs');
const path = require('path');

const LEARNINGS_DIR = path.join(__dirname, '..', 'learnings');
const AGENTS_DIR = path.join(__dirname, '..', 'claude', 'agents');
const CHANGELOG_PATH = path.join(__dirname, '..', 'LEARNING_HISTORY.md');

function readFile(filePath) {
  try { return fs.readFileSync(filePath, 'utf8'); } catch { return null; }
}

function appendToChangelog(entry) {
  const existing = readFile(CHANGELOG_PATH) || '# Lupio OS — Learning History\n\n';
  fs.writeFileSync(CHANGELOG_PATH, existing + entry);
}

function processBatch(batchDir) {
  const batchName = path.basename(batchDir);
  console.log(`\nProcessing learning batch: ${batchName}`);

  const meta      = readFile(path.join(batchDir, 'meta.md'));
  const changelog = readFile(path.join(batchDir, 'prompt-changelog.md'));
  const postmortem = readFile(path.join(batchDir, 'postmortem.md'));

  if (!changelog && !postmortem) {
    console.log('  No actionable content found, skipping.');
    return;
  }

  // Record in learning history
  const date = new Date().toISOString().split('T')[0];
  appendToChangelog(`\n## ${date} — ${batchName}\n\n${meta || ''}\n\n---\n`);

  console.log(`  ✓ Recorded in LEARNING_HISTORY.md`);
  // Future: parse changelog for structured prompt patches and apply them
  // For now: human reviews merged learnings and applies manually via /update-knowledge
}

// Process all learning batches
if (!fs.existsSync(LEARNINGS_DIR)) {
  console.log('No learnings directory found.');
  process.exit(0);
}

const batches = fs.readdirSync(LEARNINGS_DIR)
  .map(name => path.join(LEARNINGS_DIR, name))
  .filter(p => fs.statSync(p).isDirectory());

if (batches.length === 0) {
  console.log('No learning batches to process.');
  process.exit(0);
}

batches.forEach(processBatch);
console.log('\nDone. Run /update-knowledge in Claude Code to apply to agents.');
