#!/bin/bash

set -e

REPO_URL="https://github.com/hkjarral/AVA-AI-Voice-Agent-for-Asterisk.git"
REPO_DIR="AVA-AI-Voice-Agent-for-Asterisk"

echo "🚀 Starting Asterisk AI Voice Agent Installation..."

# -----------------------------
# 1. Update system
# -----------------------------
echo "📦 Updating system..."
sudo apt-get update -y

# -----------------------------
# 2. Install dependencies
# -----------------------------
echo "🔧 Installing dependencies..."
sudo apt-get install -y git curl

# -----------------------------
# 3. Install Docker (if not installed)
# -----------------------------
if ! command -v docker &> /dev/null
then
    echo "🐳 Installing Docker..."
    curl -fsSL https://get.docker.com | sudo sh
    sudo usermod -aG docker $USER
    newgrp docker
fi

# -----------------------------
# 4. Verify Docker
# -----------------------------
echo "✅ Checking Docker..."
docker --version
docker compose version

# -----------------------------
# 5. Clone OR Update repo
# -----------------------------
if [ -d "$REPO_DIR" ]; then
    echo "📁 Repo exists → updating..."
    cd "$REPO_DIR"

    git fetch --all
    git reset --hard origin/main
else
    echo "📥 Cloning repository..."
    git clone "$REPO_URL"
    cd "$REPO_DIR"
fi

# -----------------------------
# 6. Run preflight
# -----------------------------
echo "🛠 Running preflight..."
sudo ./preflight.sh --apply-fixes

# -----------------------------
# 7. Start Admin UI
# -----------------------------
echo "🌐 Starting Admin UI..."
docker compose -p asterisk-ai-voice-agent up -d --build --force-recreate admin_ui

# -----------------------------
# 8. Wait for UI
# -----------------------------
sleep 10

# -----------------------------
# 9. Start AI Engine
# -----------------------------
echo "🤖 Starting AI Engine..."
docker compose -p asterisk-ai-voice-agent up -d --build ai_engine

# -----------------------------
# 10. Health check
# -----------------------------
echo "🔍 Checking health..."
sleep 5
curl -s http://localhost:15000/health || true

echo ""
echo "✅ Installation completed!"
echo "🌐 Admin UI: http://localhost:3003"
echo "🔐 Login: admin / admin"
