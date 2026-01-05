#!/usr/bin/env bun
// Detect which PAI packs are currently installed
// Used by /atlas-pack command to show installation status

import { existsSync } from 'fs';
import { join } from 'path';
import { homedir } from 'os';

const paiDir = process.env.PAI_DIR || join(homedir(), '.claude');

// Map pack IDs to detection logic
const packDetectors: Record<string, () => boolean> = {
  // Skill Packs - check for SKILL.md in skill directory
  'kai-art-skill': () => existsSync(join(paiDir, 'skills/Art/SKILL.md')),
  'kai-agents-skill': () => existsSync(join(paiDir, 'skills/Agents/SKILL.md')),
  'kai-prompting-skill': () => existsSync(join(paiDir, 'skills/Prompting/SKILL.md')),
  'kai-browser-skill': () => existsSync(join(paiDir, 'skills/Browser/SKILL.md')),

  // System Packs - check for key files
  'kai-history-system': () => existsSync(join(paiDir, 'hooks/capture-all-events.ts')),
  'kai-hook-system': () => existsSync(join(paiDir, 'settings.json')),
  'kai-voice-system': () => existsSync(join(paiDir, 'voice/server.ts')),
  'kai-observability-server': () => existsSync(join(paiDir, 'observability/manage.sh')),

  // Core Packs
  'kai-core-install': () => existsSync(paiDir),
};

// Check each pack and output installed ones
const installed: string[] = [];
for (const [packId, detector] of Object.entries(packDetectors)) {
  if (detector()) {
    installed.push(packId);
  }
}

// Output installed pack IDs (one per line)
console.log(installed.join('\n'));
