#!/usr/bin/env node
'use strict';

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

// Determine if running via npx (from internet) or local
const isNpx = !fs.existsSync(path.join(__dirname, '..', 'installer', 'install.sh'));

if (isNpx) {
  // Running via npx lupio-os init — download and run install.sh
  console.log('\n  Lupio OS — starting installation...\n');
  execSync(
    'bash <(curl -fsSL https://raw.githubusercontent.com/your-org/lupio-os/main/installer/install.sh)',
    { stdio: 'inherit', shell: '/bin/bash' }
  );
} else {
  // Running from local clone
  const installerPath = path.join(__dirname, '..', 'installer', 'install.sh');
  execSync(`bash "${installerPath}"`, { stdio: 'inherit' });
}
