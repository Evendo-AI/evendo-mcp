# Installing the Evendo Places MCP server (instructions for AI agents)

Evendo Places is a **remote** MCP server. There is nothing to download, build or run locally, and **no API key** is required.

- Endpoint: `https://mcp.evendo.com/mcp`
- Transport: Streamable HTTP
- Auth: none currently required
- Rate limit: 200 requests per minute

## Steps

1. Open the MCP settings file for the client you are running in.
   - Cline: `cline_mcp_settings.json` (MCP Servers → Configure). With the Cline CLI you can instead run:
     `cline mcp add evendo-places https://mcp.evendo.com/mcp --transport http --yes`
2. Add this entry under `mcpServers`. Do not remove other servers already configured.

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

   Cline defaults to the legacy SSE transport when `type` is omitted, so keep `"type": "streamableHttp"`.

3. Save the file. The server should connect and list six tools:
   `resolve_place`, `find_venues`, `search_venues`, `list_subareas`, `get_venue`, `get_venues`.
4. Verify by calling `resolve_place` with `{"name": "Madrid", "place_type": "Cities", "country_code": "ES"}`. It should return Madrid with an `id`.

## Using the tools

- Always call `resolve_place` first. The other tools take Evendo place IDs, not names.
- Then call `find_venues` with that `place_id` and a `venue_type` (`Restaurants`, `Bars`, `Shopping`, `Attractions`, `Landmarks`).
- For keywords ("rooftop bar", "ramen"), use `search_venues` with `within_place_id` instead of putting the city name in `text`.
- Use `get_venues` to fetch full details for up to 50 venues at once.
- Never make up IDs, coordinates, Place Scores or cursors.
- All tools are read-only. All are safe to auto-approve.
- Full tool reference: https://evendo.com/developers/mcp/tools

## Terms

Free within the rate limit. Results may be shown to the user in the conversation. They may not be stored beyond the conversation, bulk-downloaded or used to train models. Full terms: https://evendo.com/developers/usage-and-licensing
