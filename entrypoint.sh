#!/bin/bash
set -e

# Copy host git files if mounted (avoids bind mount permission issues)
if [ -f "$HOME/.gitconfig.host" ] && [ -r "$HOME/.gitconfig.host" ]; then
    cp "$HOME/.gitconfig.host" "$HOME/.gitconfig" || echo "Warning: could not copy .gitconfig"
fi
if [ -f "$HOME/.git-credentials.host" ] && [ -r "$HOME/.git-credentials.host" ]; then
    cp "$HOME/.git-credentials.host" "$HOME/.git-credentials" && chmod 600 "$HOME/.git-credentials" || echo "Warning: could not copy .git-credentials"
fi

# Ensure git credential helper is configured for persistence
git config --global credential.helper store

# Mark mounted project directories as safe
git config --global --add safe.directory '*'

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
