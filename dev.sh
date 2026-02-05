#!/usr/bin/env bash
# dev.sh - Development server wrapper with proper cleanup

set -e

# Store PIDs of background processes
PIDS=()

# Trap Ctrl+C (SIGINT) and cleanup function
cleanup() {
    echo ""
    echo "Stopping development servers..."

    # Kill all background processes we started
    for pid in "${PIDS[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            echo "Stopping process $pid..."
            kill -TERM "$pid" 2>/dev/null || true
        fi
    done

    # Give processes time to cleanup gracefully
    sleep 1

    # Force kill any remaining processes
    for pid in "${PIDS[@]}"; do
        if kill -0 "$pid" 2>/dev/null; then
            echo "Force stopping process $pid..."
            kill -KILL "$pid" 2>/dev/null || true
        fi
    done

    echo "Development servers stopped."
    exit 0
}

# Register cleanup function for SIGINT and SIGTERM
trap cleanup SIGINT SIGTERM

echo "============================================"
echo "Starting GOTH Stack Development Environment"
echo "============================================"
echo "Press Ctrl+C to stop all services"
echo ""

# Check if Tailwind binary exists
# if [ ! -f "./tailwindcss-linux-x64" ]; then
#     echo "Error: Tailwind CSS binary not found!"
#     echo "Please download it first:"
#     echo "  wget https://github.com/tailwindlabs/tailwindcss/releases/download/v4.1.6/tailwindcss-linux-x64"
#     echo "  chmod +x tailwindcss-linux-x64"
#     exit 1
# fi

# Start Tailwind CSS watcher in background
echo "[Tailwind] Starting CSS watcher..."
tailwindcss -i ./static/input.css -o ./static/output.css --minify --watch &
TAILWIND_PID=$!
PIDS+=($TAILWIND_PID)
echo "[Tailwind] PID: $TAILWIND_PID"

# Give Tailwind a moment to start
sleep 1

# Start Air (Go server with hot reload) in foreground
echo "[Air] Starting Go server with hot reload..."
echo ""
air

# If air exits normally (not via Ctrl+C), cleanup
cleanup
