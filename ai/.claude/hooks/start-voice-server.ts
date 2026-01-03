#!/usr/bin/env bun
// $PAI_DIR/hooks/start-voice-server.ts
// Auto-start voice server on session start

import { spawn } from 'child_process';
import { homedir } from 'os';
import { join } from 'path';

const PAI_DIR = process.env.PAI_DIR || join(homedir(), '.config', 'pai');
const PORT = parseInt(process.env.PAI_VOICE_PORT || '8888');

async function checkServerRunning(): Promise<boolean> {
  try {
    const response = await fetch(`http://localhost:${PORT}/health`, {
      signal: AbortSignal.timeout(1000)
    });
    return response.ok;
  } catch {
    return false;
  }
}

async function startServer() {
  const isRunning = await checkServerRunning();

  if (isRunning) {
    console.log('✅ Voice server already running');
    return;
  }

  console.log('🎙️  Starting voice server...');

  const serverPath = join(PAI_DIR, 'voice', 'server.ts');

  // Start server in detached mode
  const child = spawn('bun', ['run', serverPath], {
    detached: true,
    stdio: 'ignore'
  });

  child.unref();

  // Wait a moment for server to start
  await new Promise(resolve => setTimeout(resolve, 1000));

  const started = await checkServerRunning();
  if (started) {
    console.log(`✅ Voice server started on port ${PORT}`);
  } else {
    console.warn('⚠️  Voice server may not have started successfully');
  }
}

startServer().catch(console.error);
