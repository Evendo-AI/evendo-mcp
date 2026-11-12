#!/usr/bin/env bash
# Publish server.json to the Official MCP Registry under com.evendo/*.
# Prereqs: mcp-publisher installed (brew install mcp-publisher), key.pem whose public key
# is in the apex evendo.com TXT record:  v=MCPv1; k=ed25519; p=<PUBLIC_KEY>
# Usage: bash scripts/publish-registry.sh [path/to/key.pem]
set -euo pipefail

KEY="${1:-key.pem}"
DOMAIN="evendo.com"
cd "$(dirname "$0")/.."

[ -f "$KEY" ] || { echo "Key not found: $KEY"; exit 1; }

VERSION="$(python3 -c 'import json;print(json.load(open("server.json"))["version"])')"
NAME="$(python3 -c 'import json;print(json.load(open("server.json"))["name"])')"
echo "Publishing $NAME@$VERSION"

# Show the TXT record value that must exist on the apex domain
PUBLIC_KEY="$(openssl pkey -in "$KEY" -pubout -outform DER | tail -c 32 | base64)"
echo "Expected TXT on $DOMAIN: v=MCPv1; k=ed25519; p=${PUBLIC_KEY}"
if command -v dig >/dev/null; then
  dig +short TXT "$DOMAIN" | grep -q "$PUBLIC_KEY" \
    && echo "DNS record found." \
    || { echo "DNS record NOT found yet (propagation?)"; exit 1; }
fi

PRIVATE_KEY="$(openssl pkey -in "$KEY" -noout -text | grep -A3 "priv:" | tail -n +2 | tr -d ' :\n')"
mcp-publisher login dns --domain "$DOMAIN" --private-key "$PRIVATE_KEY"
mcp-publisher validate
mcp-publisher publish

echo "Verifying..."
curl -s "https://registry.modelcontextprotocol.io/v0.1/servers?search=${NAME}" | python3 -m json.tool | head -n 40
