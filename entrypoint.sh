#!/bin/bash
set -e

# Copy host .gitconfig if mounted (avoids bind mount permission issues)
if [ -f "$HOME/.gitconfig.host" ] && [ -r "$HOME/.gitconfig.host" ]; then
    cp "$HOME/.gitconfig.host" "$HOME/.gitconfig" || echo "Warning: could not copy .gitconfig"
fi

# Persistent git credentials store (lives in mounted .cloudcli volume so it
# survives container restarts and tokens entered inside the container stick).
GIT_CRED_STORE="$HOME/.cloudcli/git-credentials"
mkdir -p "$(dirname "$GIT_CRED_STORE")"

# Seed from host file on first run only — never overwrite an existing store,
# otherwise tokens saved inside the container would be wiped on every restart.
if [ ! -f "$GIT_CRED_STORE" ] && [ -f "$HOME/.git-credentials.host" ] && [ -r "$HOME/.git-credentials.host" ]; then
    cp "$HOME/.git-credentials.host" "$GIT_CRED_STORE" && chmod 600 "$GIT_CRED_STORE" \
        || echo "Warning: could not seed git-credentials from host"
fi

# Point git's credential helper at the persistent file
git config --global credential.helper "store --file=$GIT_CRED_STORE"

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
