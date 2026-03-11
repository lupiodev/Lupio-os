#!/usr/bin/env node
'use strict';

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const REPO_RAW = 'https://raw.githubusercontent.com/lupiodev/Lupio-os/main';
const args = process.argv.slice(2);
const command = args[0] || 'init';

function run(cmd) {
  execSync(cmd, { stdio: 'inherit', shell: '/bin/bash' });
}

function hasLocalInstaller() {
  return fs.existsSync(path.join(__dirname, '..', 'installer', 'install.sh'));
}

switch (command) {
  case 'init':
  case 'install':
    console.log('\n  Lupio OS — installing...\n');
    if (hasLocalInstaller()) {
      run(`bash "${path.join(__dirname, '..', 'installer', 'install.sh')}"`);
    } else {
      run(`bash <(curl -fsSL ${REPO_RAW}/installer/install.sh)`);
    }
    break;

  case 'update':
    console.log('\n  Lupio OS — updating...\n');
    if (!fs.existsSync('.lupio')) {
      console.error('Error: .lupio/ not found. Run "npx lupio-os init" first.');
      process.exit(1);
    }
    if (hasLocalInstaller()) {
      run(`bash "${path.join(__dirname, '..', 'scripts', 'update.sh')}"`);
    } else {
      run(`bash <(curl -fsSL ${REPO_RAW}/scripts/update.sh)`);
    }
    break;

  case 'version':
  case '--version':
  case '-v': {
    const pkg = JSON.parse(fs.readFileSync(path.join(__dirname, '..', 'package.json'), 'utf8'));
    console.log(`lupio-os v${pkg.version}`);
    break;
  }

  case 'help':
  case '--help':
  case '-h':
    console.log(`
  Lupio OS — AI Development Operating System for Claude Code

  Usage:
    npx lupio-os init      Install Lupio OS into the current project
    npx lupio-os update    Update agents, commands, and templates
    npx lupio-os version   Show installed version

  Docs: https://github.com/lupiodev/Lupio-os
`);
    break;

  default:
    console.error(`Unknown command: ${command}. Run "npx lupio-os help" for usage.`);
    process.exit(1);
}
