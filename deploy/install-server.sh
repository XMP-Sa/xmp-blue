#!/bin/bash
# XMP Server — one-shot install on a Debian/Ubuntu VPS.
# Usage:  sudo bash install-server.sh [server-name]
set -e

NAME="${1:-XMP Server}"
REPO="XMP-Sa/xmp-blue"
DEST="/opt/xmp-server"

echo "==> creating xmp user + directories"
id xmp >/dev/null 2>&1 || useradd -r -s /usr/sbin/nologin xmp
mkdir -p "$DEST"

echo "==> downloading latest XMP Server release"
URL=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
  | grep -o '"browser_download_url": *"[^"]*XMP-Server-linux-x64.tar.gz"' \
  | cut -d'"' -f4 | head -1)
[ -n "$URL" ] || { echo "release asset not found — is there a tagged release?"; exit 1; }
curl -fSL "$URL" -o /tmp/xmp-server.tar.gz
tar -xzf /tmp/xmp-server.tar.gz -C "$DEST"

echo "==> configuring"
cd "$DEST"
[ -f mods/deathmatch/mtaserver.conf ] && \
  sed -i "s|<servername>.*</servername>|<servername>${NAME}</servername>|" mods/deathmatch/mtaserver.conf
chmod +x xmp-server64
chown -R xmp:xmp "$DEST"

echo "==> installing systemd service"
cp "$(dirname "$0")/xmp-server.service" /etc/systemd/system/xmp-server.service 2>/dev/null || true
systemctl daemon-reload
systemctl enable --now xmp-server

echo "==> opening firewall (ufw, if present)"
command -v ufw >/dev/null && { ufw allow 22003/udp || true; ufw allow 22126/udp || true; ufw allow 22005/tcp || true; } || true

echo "done. status: systemctl status xmp-server   logs: journalctl -u xmp-server -f"
