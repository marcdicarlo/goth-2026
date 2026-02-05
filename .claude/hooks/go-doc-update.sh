#!/bin/bash
# Auto-format Go code and check for missing godoc comments
# Outputs prompt when documentation needs updating

set -e

# Read JSON input from stdin
INPUT=$(cat)

# Extract file path from tool input
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# Only process .go files (ignore generated _templ.go files)
if [[ "$FILE_PATH" != *.go ]] || [[ "$FILE_PATH" == *_templ.go ]] || [[ -z "$FILE_PATH" ]]; then
  exit 0
fi

# Skip if file doesn't exist (might have been deleted)
if [[ ! -f "$FILE_PATH" ]]; then
  exit 0
fi

# Rate limiting: Only check once per minute to avoid spam
LAST_RUN_FILE="/tmp/.goth-godoc-last-run"
CURRENT_TIME=$(date +%s)

if [ -f "$LAST_RUN_FILE" ]; then
  LAST_RUN=$(cat "$LAST_RUN_FILE")
  TIME_DIFF=$((CURRENT_TIME - LAST_RUN))

  # Skip if less than 60 seconds since last check
  if [ "$TIME_DIFF" -lt 60 ]; then
    exit 0
  fi
fi

# Update last run timestamp
echo "$CURRENT_TIME" > "$LAST_RUN_FILE"

# Auto-format the Go file
if command -v gofmt &> /dev/null; then
  gofmt -w "$FILE_PATH" 2>/dev/null || true
fi

# Check for undocumented exported identifiers
# Look for exported functions, types, structs without godoc comments
MISSING_DOCS=false

# Check for exported functions without comments (simplified check)
if grep -E '^func [A-Z]' "$FILE_PATH" > /dev/null 2>&1; then
  # Check if there are lines with 'func [A-Z]' not preceded by '//'
  if grep -B1 -E '^func [A-Z]' "$FILE_PATH" | grep -v '^//' | grep -E '^func [A-Z]' > /dev/null 2>&1; then
    MISSING_DOCS=true
  fi
fi

# Check for exported types without comments
if grep -E '^type [A-Z]' "$FILE_PATH" > /dev/null 2>&1; then
  if grep -B1 -E '^type [A-Z]' "$FILE_PATH" | grep -v '^//' | grep -E '^type [A-Z]' > /dev/null 2>&1; then
    MISSING_DOCS=true
  fi
fi

# If missing docs found, prompt for action
if [ "$MISSING_DOCS" = true ]; then
  cat << EOF
📝 Documentation check: $FILE_PATH

Missing godoc comments detected. To add documentation:
  /godoc-documenter

(This will spawn a Haiku agent to add proper godoc comments following conventions)
EOF
fi

exit 0
