#!/bin/bash
set -e

# If first argument is "login", run claude login interactively
if [ "$1" = "login" ]; then
    echo "=== Claude Code Login ==="
    echo "Follow the instructions to authenticate with your Claude account."
    echo ""
    claude login
    echo ""
    echo "Login complete! Now start the UI with: docker compose up -d"
    exit 0
fi

# Otherwise, start the UI
exec "$@"
