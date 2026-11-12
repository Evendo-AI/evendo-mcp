# Evendo Places MCP Server

**Give your agents a sense of place.**

Evendo Places is a hosted, read-only [Model Context Protocol](https://modelcontextprotocol.io) server. It gives AI agents a structured model of the world's places. Agents resolve a country, region, city or neighbourhood, then find, filter and rank the restaurants, bars, shopping, attractions and landmarks inside it, using the **Evendo Place Score** (0–100).

- **Endpoint:** `https://mcp.evendo.com/mcp`
- **Transport:** Streamable HTTP
- **Auth:** none currently required, so you need no API key and no account
- **Rate limit:** 200 requests per minute
- **Registry name:** `com.evendo/places`

## Install

[![Add to Cursor](https://img.shields.io/badge/Cursor-Add_Evendo_Places-000000?logo=cursor)](cursor://anysphere.cursor-deeplink/mcp/install?name=evendo-places&config=eyJ1cmwiOiJodHRwczovL21jcC5ldmVuZG8uY29tL21jcCJ9)
[![Install in VS Code](https://img.shields.io/badge/VS_Code-Install_Evendo_Places-0098FF?logo=visualstudiocode)](https://vscode.dev/redirect?url=vscode%3Amcp%2Finstall%3F%257B%2522name%2522%253A%2522evendo-places%2522%252C%2522type%2522%253A%2522http%2522%252C%2522url%2522%253A%2522https%253A%2F%2Fmcp.evendo.com%2Fmcp%2522%257D)

<details>
<summary><b>Cursor</b> (<code>~/.cursor/mcp.json</code>)</summary>

```json
{ "mcpServers": { "evendo-places": { "url": "https://mcp.evendo.com/mcp" } } }
```
</details>

<details>
<summary><b>VS Code</b> (<code>.vscode/mcp.json</code>)</summary>

```json
{ "servers": { "evendo-places": { "type": "http", "url": "https://mcp.evendo.com/mcp" } } }
```
</details>

<details>
<summary><b>Cline</b> (<code>cline_mcp_settings.json</code>)</summary>

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
</details>

<details>
<summary><b>Claude</b></summary>

Settings → Connectors → Add custom connector → URL `https://mcp.evendo.com/mcp`.
</details>

<details>
<summary><b>Docker MCP Toolkit</b></summary>

```bash
docker mcp server enable evendo
```
</details>

<details>
<summary><b>Any other client</b></summary>

Point a Streamable HTTP MCP client at `https://mcp.evendo.com/mcp`. No headers are required.
</details>

## Tools

All tools are read-only (`readOnlyHint: true`).

| Tool | What it does |
| --- | --- |
| `resolve_place` | Turns a country, region, city or neighbourhood name into an Evendo place ID. Call this first. |
| `find_venues` | Lists restaurants, bars, shopping, attractions or landmarks in a place. Filters cover price, rating, ambience, audience, accessibility, weather and distance. Results sort by Place Score, rating, reviews or distance. |
| `search_venues` | Keyword search over venue names, taglines and descriptions. |
| `list_subareas` | Lists a place's direct children, such as a city's neighbourhoods. |
| `get_venue` | Full detail for one venue: description, address, coordinates, contact, booking link, photos, tags and Place Score. |
| `get_venues` | The same detail for up to 50 venues in one call. |

Full reference: https://evendo.com/developers/mcp/tools · Quickstart: https://evendo.com/developers/mcp/quickstart

Cursor users also get `rules/evendo-places.mdc`, which teaches the agent the right call order.

## Try it

- "Find the 10 best-scoring attractions in Madrid."
- "Top-rated cheap Italian restaurants in Prague's Old Town."
- "Family-friendly outdoor attractions in Scotland that work in the rain."
- "Romantic bars within 1 km of 51.5072, -0.1276, nearest first."
- "Plan a food-focused day in Lisbon: list its neighbourhoods, then three restaurants in each."

## Usage and licensing

The service is free within the rate limit. You may show results to your user within the conversation. You may not store results beyond the conversation, bulk-download or crawl them, use them to train models, or redistribute them. See [Usage & licensing](https://evendo.com/developers/usage-and-licensing). For commercial or higher-volume use, contact support@evendo.com.

The contents of this repository (configuration and documentation) are MIT-licensed. That licence does not cover the Evendo service or its data.

## Support

- Help Centre: https://help.evendo.com
- Email: support@evendo.com
- Docs: https://evendo.com/developers
