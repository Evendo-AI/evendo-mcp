# Connect Evendo Places to your AI client

> Page draft for **evendo.com/developers/mcp/clients**. Catalog listings link here, so keep it in sync with `README.md`.

Evendo Places is a hosted MCP server. You need no API key, no account and no install. Point your client at the endpoint and the six read-only tools appear.

| | |
| --- | --- |
| Endpoint | `https://mcp.evendo.com/mcp` |
| Transport | Streamable HTTP |
| Auth | None currently required |
| Rate limit | 200 requests/minute |
| Registry name | `com.evendo/places` |

## Claude (claude.ai, Desktop)

Open **Settings → Connectors → Add custom connector**, name it `Evendo Places` and enter the URL `https://mcp.evendo.com/mcp`.

## Claude Code

```bash
claude mcp add --transport http evendo-places https://mcp.evendo.com/mcp
```

## Cursor

[Add to Cursor](cursor://anysphere.cursor-deeplink/mcp/install?name=evendo-places&config=eyJ1cmwiOiJodHRwczovL21jcC5ldmVuZG8uY29tL21jcCJ9), or add this to `~/.cursor/mcp.json`:

```json
{ "mcpServers": { "evendo-places": { "url": "https://mcp.evendo.com/mcp" } } }
```

## VS Code (GitHub Copilot agent mode)

[Install in VS Code](https://vscode.dev/redirect?url=vscode%3Amcp%2Finstall%3F%257B%2522name%2522%253A%2522evendo-places%2522%252C%2522type%2522%253A%2522http%2522%252C%2522url%2522%253A%2522https%253A%2F%2Fmcp.evendo.com%2Fmcp%2522%257D), or add this to `.vscode/mcp.json`:

```json
{ "servers": { "evendo-places": { "type": "http", "url": "https://mcp.evendo.com/mcp" } } }
```

## Cline

Install from the Cline MCP Marketplace, or add this to `cline_mcp_settings.json`:

```json
{
  "mcpServers": {
    "evendo-places": {
      "type": "streamableHttp",
      "url": "https://mcp.evendo.com/mcp",
      "disabled": false,
      "autoApprove": []
    }
  }
}
```

Keep `"type": "streamableHttp"`, because Cline otherwise falls back to SSE.

## Windsurf

Add this to `~/.codeium/windsurf/mcp_config.json`:

```json
{ "mcpServers": { "evendo-places": { "serverUrl": "https://mcp.evendo.com/mcp" } } }
```

## Docker MCP Toolkit

```bash
docker mcp server enable evendo
```

## Any other client or SDK

Connect a Streamable HTTP MCP client to `https://mcp.evendo.com/mcp`. No headers are needed.

## Check it works

Ask your assistant: *"Use Evendo to find the 10 best-scoring attractions in Madrid."* It should call `resolve_place`, then `find_venues`.

## Terms

Results may be shown to your user within the conversation. They may not be stored beyond it, bulk-downloaded, used for model training or redistributed. See [Usage & licensing](https://evendo.com/developers/usage-and-licensing).
