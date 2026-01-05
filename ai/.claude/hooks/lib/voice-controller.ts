#!/usr/bin/env bun
// $PAI_DIR/hooks/lib/voice-controller.ts
// Controls voice personality switching for Atlas

import { existsSync, mkdirSync, writeFileSync, readFileSync } from 'fs';
import { join } from 'path';
import { homedir } from 'os';

const paiDir = process.env.PAI_DIR || join(homedir(), '.claude');
const stateDir = join(paiDir, 'state');
const personalityFile = join(stateDir, 'current-personality.txt');

// Available personalities (must match voice-personalities.json)
const VALID_PERSONALITIES = [
  'pai', 'default',  // Primary
  'intern', 'engineer', 'architect', 'researcher',
  'designer', 'artist', 'pentester', 'writer'
];

interface PersonalityInfo {
  name: string;
  description: string;
}

const PERSONALITY_INFO: Record<string, PersonalityInfo> = {
  'pai': { name: 'PAI', description: 'Professional, expressive - primary AI assistant' },
  'default': { name: 'Default', description: 'Same as PAI' },
  'intern': { name: 'Intern', description: 'Enthusiastic, chaotic energy - eager 176 IQ genius' },
  'engineer': { name: 'Engineer', description: 'Wise leader, stable - Fortune 10 principal engineer' },
  'architect': { name: 'Architect', description: 'Wise leader, deliberate - PhD-level system designer' },
  'researcher': { name: 'Researcher', description: 'Analyst, measured - comprehensive research specialist' },
  'designer': { name: 'Designer', description: 'Critic, measured - exacting UX/UI specialist' },
  'artist': { name: 'Artist', description: 'Enthusiast, chaotic - visual content creator' },
  'pentester': { name: 'Pentester', description: 'Enthusiast, chaotic - offensive security specialist' },
  'writer': { name: 'Writer', description: 'Professional, expressive - content creation specialist' }
};

/**
 * Ensure state directory exists
 */
function ensureStateDir(): void {
  if (!existsSync(stateDir)) {
    mkdirSync(stateDir, { recursive: true });
  }
}

/**
 * Get current personality
 */
export function getCurrentPersonality(): string {
  try {
    if (existsSync(personalityFile)) {
      const personality = readFileSync(personalityFile, 'utf-8').trim().toLowerCase();
      if (VALID_PERSONALITIES.includes(personality)) {
        return personality;
      }
    }
  } catch {
    // Ignore errors
  }
  return 'pai'; // Default
}

/**
 * Set current personality
 */
function setPersonality(personality: string): boolean {
  const normalized = personality.toLowerCase();

  if (!VALID_PERSONALITIES.includes(normalized)) {
    console.error(`Invalid personality: ${personality}`);
    console.error(`Valid options: ${VALID_PERSONALITIES.join(', ')}`);
    return false;
  }

  ensureStateDir();
  writeFileSync(personalityFile, normalized);
  return true;
}

/**
 * List all available personalities
 */
function listPersonalities(): void {
  const current = getCurrentPersonality();

  console.log('\n🎙️  Atlas Voice Personalities\n');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  for (const [id, info] of Object.entries(PERSONALITY_INFO)) {
    const marker = id === current ? '▶️ ' : '  ';
    console.log(`${marker}${id.padEnd(12)} - ${info.description}`);
  }

  console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  console.log(`\nCurrent: ${current}`);
  console.log('Usage: /atlas-voice <personality>\n');
}

// Main CLI handler
function main() {
  const args = process.argv.slice(2);

  // Parse arguments
  let personality: string | null = null;
  let showList = false;

  for (let i = 0; i < args.length; i++) {
    if (args[i] === '--personality' && args[i + 1]) {
      personality = args[i + 1];
      i++;
    } else if (args[i] === '--list' || args[i] === '-l') {
      showList = true;
    } else if (args[i] === '--current' || args[i] === '-c') {
      console.log(getCurrentPersonality());
      process.exit(0);
    } else if (!args[i].startsWith('-')) {
      // Positional argument as personality
      personality = args[i];
    }
  }

  if (showList || (!personality && args.length === 0)) {
    listPersonalities();
    process.exit(0);
  }

  if (personality) {
    const success = setPersonality(personality);
    if (success) {
      const info = PERSONALITY_INFO[personality.toLowerCase()];
      console.log(`\n✅ Voice personality switched to: ${personality}`);
      if (info) {
        console.log(`   ${info.description}`);
      }
      console.log('\nThis will affect voice output for the rest of this session.\n');
      process.exit(0);
    } else {
      process.exit(1);
    }
  }
}

// Run if called directly
if (import.meta.main) {
  main();
}
