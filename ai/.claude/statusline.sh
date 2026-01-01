#!/bin/bash

# Source style configuration
source "$HOME/.claude/statusline-style.sh"

# Read JSON input from stdin
INPUT=$(cat)

# Extract values from JSON
MODEL=$(echo "$INPUT" | jq -r '.model.display_name // "Claude"')
CWD=$(echo "$INPUT" | jq -r '.workspace.current_dir // .cwd')
VERSION=$(echo "$INPUT" | jq -r '.version // ""')

# Show only current directory name with ~.../ prefix
CWD_DISPLAY="...$(basename "$CWD")"

# Get context usage
CONTEXT_SIZE=$(echo "$INPUT" | jq -r '.context_window.context_window_size // 0')
CURRENT_USAGE=$(echo "$INPUT" | jq '.context_window.current_usage // null')

CONTEXT_BAR=""
if [ "$CURRENT_USAGE" != "null" ] && [ "$CONTEXT_SIZE" -gt 0 ]; then
  INPUT_TOKENS=$(echo "$CURRENT_USAGE" | jq -r '.input_tokens // 0')
  CACHE_CREATE=$(echo "$CURRENT_USAGE" | jq -r '.cache_creation_input_tokens // 0')
  CACHE_READ=$(echo "$CURRENT_USAGE" | jq -r '.cache_read_input_tokens // 0')
  TOTAL_TOKENS=$((INPUT_TOKENS + CACHE_CREATE + CACHE_READ))
  PERCENT_USED=$((TOTAL_TOKENS * 100 / CONTEXT_SIZE))

  # Progress bar settings
  BAR_WIDTH=20
  FILLED=$((PERCENT_USED * BAR_WIDTH / 100))
  EMPTY=$((BAR_WIDTH - FILLED))

  # Build progress bar
  BAR_FILLED=$(printf '█%.0s' $(seq 1 $FILLED 2>/dev/null) || echo "")
  BAR_EMPTY=$(printf '░%.0s' $(seq 1 $EMPTY 2>/dev/null) || echo "")

  # Color based on usage level
  if [ "$PERCENT_USED" -ge 80 ]; then
    BAR_COLOR="$COLOR_RED"
  elif [ "$PERCENT_USED" -ge 50 ]; then
    BAR_COLOR="$COLOR_YELLOW"
  else
    BAR_COLOR="$COLOR_GREEN"
  fi

  CONTEXT_BAR="${EMOJI_CONTEXT} ${BAR_COLOR}${BAR_FILLED}${COLOR_RESET}${BAR_EMPTY} ${PERCENT_USED}%%"

  # Calculate cache hit rate
  CACHE_TOTAL=$((CACHE_READ + CACHE_CREATE))
  if [ "$CACHE_TOTAL" -gt 0 ]; then
    CACHE_HIT_RATE=$((CACHE_READ * 100 / CACHE_TOTAL))
    # Color based on cache efficiency
    if [ "$CACHE_HIT_RATE" -ge 70 ]; then
      CACHE_COLOR="$COLOR_GREEN"
    elif [ "$CACHE_HIT_RATE" -ge 40 ]; then
      CACHE_COLOR="$COLOR_YELLOW"
    else
      CACHE_COLOR="$COLOR_RED"
    fi
    CACHE_DISPLAY="${EMOJI_CACHE} ${CACHE_COLOR}${CACHE_HIT_RATE}%%${COLOR_RESET}"
  fi
fi

# Build status line: Version | Model | Context | CWD
if [ -n "$VERSION" ] && [ "$VERSION" != "null" ]; then
  printf "${VERSION_COLOR}${EMOJI_VERSION} v${VERSION}${COLOR_RESET}"
  printf "${SEPARATOR}"
fi

printf "${MODEL_COLOR}${EMOJI_MODEL} ${MODEL}${COLOR_RESET}"

if [ -n "$CONTEXT_BAR" ]; then
  printf "${SEPARATOR}"
  printf "${CONTEXT_BAR}"
fi

if [ -n "$CACHE_DISPLAY" ]; then
  printf "${SEPARATOR}"
  printf "${CACHE_DISPLAY}"
fi

printf "${SEPARATOR}"
printf "${PROJECT_COLOR}${EMOJI_PROJECT} ${CWD_DISPLAY}${COLOR_RESET}"

printf "\n"
