---
description: "Manage Atlas observability dashboard. Usage: /atlas:observability [start|stop|restart|status]"
---

# Atlas Observability Dashboard

Real-time multi-agent activity monitoring dashboard - see exactly what your AI agents are doing as they work.

## Features

- **WebSocket Streaming**: Events appear instantly as they happen
- **Multi-Agent Tracking**: See activity across all agents
- **Event Timeline**: Chronological view of all operations
- **Agent Swim Lanes**: Compare activity between multiple agents

## Usage

**Action:** $ARGUMENTS

!if [ -f ~/.claude/observability/manage.sh ]; then \
  case "$1" in \
    start|"") \
      echo "🚀 Starting Atlas Observability Dashboard..."; \
      ~/.claude/observability/manage.sh start; \
      echo ""; \
      echo "Dashboard available at:"; \
      echo "  http://localhost:5173"; \
      echo ""; \
      echo "Use /atlas:observability stop to shut down"; \
      ;; \
    stop) \
      echo "⏹️  Stopping Atlas Observability Dashboard..."; \
      ~/.claude/observability/manage.sh stop; \
      ;; \
    restart) \
      echo "🔄 Restarting Atlas Observability Dashboard..."; \
      ~/.claude/observability/manage.sh restart; \
      ;; \
    status) \
      echo "📊 Observability Dashboard Status:"; \
      ~/.claude/observability/manage.sh status || echo "Status check not available"; \
      ;; \
    *) \
      echo "Unknown action: $1"; \
      echo "Available actions: start, stop, restart, status"; \
      ;; \
  esac; \
else \
  echo "❌ Observability server not installed"; \
  echo ""; \
  echo "To install, run: /atlas:install kai-observability-server"; \
fi
