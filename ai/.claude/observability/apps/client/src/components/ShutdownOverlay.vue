<script setup lang="ts">
defineProps<{
  show: boolean;
}>();
</script>

<template>
  <Transition name="fade">
    <div v-if="show" class="shutdown-overlay">
      <div class="shutdown-card glass-panel-elevated">
        <div class="shutdown-icon">✨</div>
        <h2 class="shutdown-title">Session Ended</h2>
        <p class="shutdown-message">The observability server has stopped gracefully.</p>
        <p class="shutdown-subtitle">This happens when the Claude Code session closes.</p>
        <div class="shutdown-footer">
          <div class="pulse-indicator"></div>
          <span class="footer-text">Server disconnected</span>
        </div>
      </div>
    </div>
  </Transition>
</template>

<style scoped>
.shutdown-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.85);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  display: grid;
  place-items: center;
  z-index: 9999;
  animation: overlayFadeIn 0.3s ease-out;
}

@keyframes overlayFadeIn {
  from {
    background: rgba(0, 0, 0, 0);
    backdrop-filter: blur(0px);
  }
  to {
    background: rgba(0, 0, 0, 0.85);
    backdrop-filter: blur(12px);
  }
}

.shutdown-card {
  padding: 3rem 4rem;
  border-radius: 1.5rem;
  text-align: center;
  max-width: 500px;
  width: 90%;
  box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
  animation: cardSlideIn 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
}

@keyframes cardSlideIn {
  from {
    transform: translateY(-20px) scale(0.95);
    opacity: 0;
  }
  to {
    transform: translateY(0) scale(1);
    opacity: 1;
  }
}

.shutdown-icon {
  font-size: 4rem;
  margin-bottom: 1.5rem;
  animation: iconPulse 2s ease-in-out infinite;
}

@keyframes iconPulse {
  0%, 100% {
    transform: scale(1);
    opacity: 1;
  }
  50% {
    transform: scale(1.1);
    opacity: 0.8;
  }
}

.shutdown-title {
  font-size: 2rem;
  font-weight: 700;
  margin-bottom: 1rem;
  background: linear-gradient(135deg, var(--color-text-primary, #ffffff), var(--color-text-secondary, #a0a0a0));
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.shutdown-message {
  font-size: 1.125rem;
  color: var(--color-text-primary, #e0e0e0);
  margin-bottom: 0.75rem;
  line-height: 1.6;
}

.shutdown-subtitle {
  font-size: 0.875rem;
  color: var(--color-text-secondary, #a0a0a0);
  opacity: 0.7;
  margin-bottom: 2rem;
}

.shutdown-footer {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
  padding-top: 1.5rem;
  border-top: 1px solid rgba(255, 255, 255, 0.1);
}

.pulse-indicator {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: #ef4444;
  box-shadow: 0 0 10px rgba(239, 68, 68, 0.5);
  animation: pulse 2s ease-in-out infinite;
}

@keyframes pulse {
  0%, 100% {
    opacity: 1;
    transform: scale(1);
  }
  50% {
    opacity: 0.4;
    transform: scale(0.8);
  }
}

.footer-text {
  font-size: 0.875rem;
  color: var(--color-text-secondary, #a0a0a0);
  text-transform: uppercase;
  letter-spacing: 0.05em;
  font-weight: 500;
}

/* Transition classes */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.5s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.fade-enter-active .shutdown-card {
  transition: transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.fade-enter-from .shutdown-card {
  transform: scale(0.9) translateY(-20px);
}
</style>
