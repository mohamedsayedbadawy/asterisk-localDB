#!/bin/bash

# ─────────────────────────────────────────────
# AVA Project — Full Config Backup Script
# ─────────────────────────────────────────────

BACKUP_DIR=~/backups/AVA-$(date +%Y%m%d_%H%M%S)
mkdir -p "$BACKUP_DIR"/{asterisk,ava,freepbx}

echo "📦 Backup started → $BACKUP_DIR"
echo "─────────────────────────────────────────"

# ── 1. AVA Config Files ──────────────────────
echo "[ 1/4 ] Backing up AVA config files..."
cp ~/AVA-AI-Voice-Agent-for-Asterisk/config/ai-agent.yaml         "$BACKUP_DIR/ava/"
cp ~/AVA-AI-Voice-Agent-for-Asterisk/config/ai-agent.local.yaml   "$BACKUP_DIR/ava/"
cp ~/AVA-AI-Voice-Agent-for-Asterisk/docker-compose.yml           "$BACKUP_DIR/ava/"
cp ~/AVA-AI-Voice-Agent-for-Asterisk/.env                         "$BACKUP_DIR/ava/" 2>/dev/null || echo "  ⚠ .env not found"

# ── 2. Asterisk Config Files ─────────────────
echo "[ 2/4 ] Backing up Asterisk config files..."
sudo cp /etc/asterisk/extensions_custom.conf    "$BACKUP_DIR/asterisk/"
sudo cp /etc/asterisk/dongle.conf               "$BACKUP_DIR/asterisk/"
sudo cp /etc/asterisk/pjsip_additional.conf     "$BACKUP_DIR/asterisk/" 2>/dev/null || echo "  ⚠ pjsip_additional.conf not found"
sudo cp /etc/asterisk/pjsip_general_additional.conf "$BACKUP_DIR/asterisk/" 2>/dev/null || echo "  ⚠ pjsip_general_additional.conf not found"
sudo cp /etc/asterisk/ari_additional.conf       "$BACKUP_DIR/asterisk/" 2>/dev/null || echo "  ⚠ ari_additional.conf not found"
sudo cp /etc/asterisk/ari_general_additional.conf "$BACKUP_DIR/asterisk/" 2>/dev/null || echo "  ⚠ ari_general_additional.conf not found"

# ── 3. FreePBX DB Export ─────────────────────
echo "[ 3/4 ] Exporting FreePBX settings..."
sudo fwconsole backup --backup-name="config-backup-$(date +%Y%m%d)" 2>/dev/null || echo "  ⚠ fwconsole backup skipped"

# ── 4. Show Result ───────────────────────────
echo "[ 4/4 ] Done!"
echo "─────────────────────────────────────────"
echo "✅ Backup saved to: $BACKUP_DIR"
echo ""
echo "Files backed up:"
find "$BACKUP_DIR" -type f | sort
echo ""
echo "Total size: $(du -sh $BACKUP_DIR | cut -f1)"
