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

# Create directories for persistent data
RUN mkdir -p /root/.claude /root/.anthropic

# Expose the default port
EXPOSE 3001

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3001

# Entrypoint script to handle login or start
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["cloudcli"]
