#!/usr/bin/env bash
# Smoke test for the Evendo Places MCP server (Streamable HTTP).
# Run from any machine with outside internet access:  bash scripts/smoke-test.sh
# Checks: initialize, tools/list (expects six read-only tools), and one resolve_place call.
set -euo pipefail

URL="${1:-https://mcp.evendo.com/mcp}"
HDRS=(-H 'Content-Type: application/json' -H 'Accept: application/json, text/event-stream')
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT

# Responses may be plain JSON or SSE ("data: {...}"); normalise to JSON.
body() { sed -n 's/^data: //p' "$1" | tail -n 1 | grep . || cat "$1"; }

echo "1/3 initialize -> $URL"
curl -sS -D "$TMP/h" "${HDRS[@]}" "$URL" -o "$TMP/init" -d '{
  "jsonrpc":"2.0","id":1,"method":"initialize",
  "params":{"protocolVersion":"2025-06-18","capabilities":{},
            "clientInfo":{"name":"evendo-smoke-test","version":"1.0"}}}'
SID="$(grep -i '^mcp-session-id:' "$TMP/h" | awk '{print $2}' | tr -d '\r' || true)"
SESSION=(); [ -n "$SID" ] && SESSION=(-H "Mcp-Session-Id: $SID")
body "$TMP/init" | python3 -c 'import sys,json; r=json.load(sys.stdin)["result"]; print("   server:", r["serverInfo"], "| protocol:", r["protocolVersion"])'

curl -sS "${HDRS[@]}" "${SESSION[@]}" "$URL" -o /dev/null \
  -d '{"jsonrpc":"2.0","method":"notifications/initialized"}'

echo "2/3 tools/list"
curl -sS "${HDRS[@]}" "${SESSION[@]}" "$URL" -o "$TMP/tools" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list"}'
body "$TMP/tools" | python3 -c '
import sys, json
tools = json.load(sys.stdin)["result"]["tools"]
expected = {"resolve_place","find_venues","search_venues","list_subareas","get_venue","get_venues"}
names = {t["name"] for t in tools}
for t in tools:
    a = t.get("annotations", {})
    title = t.get("title") or a.get("title") or "MISSING"
    print("   %-15s title=%-16s readOnly=%s" % (t["name"], title, a.get("readOnlyHint")))
missing = expected - names
if missing: sys.exit(f"   FAIL: missing tools {missing}")
if any(not (t.get("title") or t.get("annotations",{}).get("title")) for t in tools):
    print("   WARN: some tools have no title (required by Claude connectors directory)")
print("   OK: all six tools present")'

echo "3/3 tools/call resolve_place(Madrid)"
curl -sS "${HDRS[@]}" "${SESSION[@]}" "$URL" -o "$TMP/call" -d '{
  "jsonrpc":"2.0","id":3,"method":"tools/call",
  "params":{"name":"resolve_place","arguments":{"name":"Madrid","place_type":"Cities","country_code":"ES"}}}'
body "$TMP/call" | python3 -c 'import sys,json; r=json.load(sys.stdin); print("   OK" if "result" in r and not r["result"].get("isError") else f"   FAIL: {r}")'
