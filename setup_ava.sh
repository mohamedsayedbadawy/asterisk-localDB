#!/bin/bash
# ============================================================
# Maintelecom — AVA AI Agent Setup Script
# ============================================================

echo ""
echo "============================================"
echo " Maintelecom AVA AI Agent Setup"
echo "============================================"
echo ""

# Variables
AVA_CONFIG="/home/maintelecom/AVA-AI-Voice-Agent-for-Asterisk/config/ai-agent.local.yaml"
AVA_DIR="/home/maintelecom/AVA-AI-Voice-Agent-for-Asterisk"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Step 1 — Backup AVA config
echo "[1/3] Creating backup..."
cp "$AVA_CONFIG" "$AVA_CONFIG.bak.$TIMESTAMP"
echo "      Backup saved: $AVA_CONFIG.bak.$TIMESTAMP"

# Step 2 — Update AVA config
echo "[2/3] Updating AVA AI Agent config..."
cat > "$AVA_CONFIG" << 'EOF'
contexts:
  default:
    greeting: 'Hello, I am AVA, Maintelecom customer service assistant. How can I help you?'
    provider: openai_realtime
    prompt: |
      You are AVA, a helpful AI customer service assistant for Maintelecom.

      When the customer speaks, listen carefully and try to resolve
      their issue professionally and concisely.

      If the customer needs human help because:
      - They say "I need a human", "transfer me", "speak to someone"
      - You cannot resolve the issue after 2 attempts

      Then say exactly:
      "Of course, please hold while I transfer you to a customer service representative."
      Then immediately use the hangup_call tool to end the session.
      The system will automatically transfer to a human agent.

      Always be polite and professional.
    tools:
      - hangup_call

default_provider: openai_realtime

tools:
  hangup_call:
    enabled: true
    farewell_message: Thank you for calling Maintelecom. Goodbye!
    require_confirmation: false
  cancel_transfer:
    enabled: false
  attended_transfer:
    enabled: false
EOF
echo "      AVA config updated successfully!"

# Step 3 — Restart AVA
echo "[3/3] Restarting AVA AI Engine..."
cd "$AVA_DIR"
docker compose restart ai_engine
echo "      AVA restarted!"

echo ""
echo "============================================"
echo " Setup Complete!"
echo "============================================"
echo ""
echo " Test by calling 7000 or dongle number"
echo " Say 'I need a human' to test transfer"
echo " Transfer goes to: 2005 → 113 in 3CX"
echo ""
echo " Verify with:"
echo "   sudo asterisk -rx 'ari show apps'"
echo "   sudo docker logs \$(sudo docker ps -q) --tail 20"
echo "============================================"
