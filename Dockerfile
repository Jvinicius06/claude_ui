FROM node:22-bookworm

# Install system dependencies for native modules (node-pty, better-sqlite3, bcrypt)
RUN apt-get update && apt-get install -y \
    build-essential \
    python3 \
    git \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI globally
RUN npm install -g @anthropic-ai/claude-code

# Install Claude Code UI globally
RUN npm install -g @siteboon/claude-code-ui@latest

# Create non-root user to avoid CLI root permission issues
RUN useradd -m -s /bin/bash claudeuser

# Create directories for persistent data with correct ownership
RUN mkdir -p /home/claudeuser/.claude /home/claudeuser/.anthropic \
    && chown -R claudeuser:claudeuser /home/claudeuser/.claude /home/claudeuser/.anthropic

# Expose the default port
EXPOSE 3001

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3001
ENV HOME=/home/claudeuser

# Switch to non-root user
USER claudeuser
WORKDIR /home/claudeuser

# Entrypoint script to handle login or start
COPY --chown=claudeuser:claudeuser entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cloudcli"]
