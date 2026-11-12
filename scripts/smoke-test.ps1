# Smoke test for the Evendo Places MCP server (Streamable HTTP), PowerShell version.
# Run:  powershell -ExecutionPolicy Bypass -File scripts\smoke-test.ps1
# Checks: initialize, tools/list (expects six read-only tools with titles), and one resolve_place call.
param([string]$Url = "https://mcp.evendo.com/mcp")
$ErrorActionPreference = "Stop"
$Headers = @{ "Accept" = "application/json, text/event-stream" }

# Responses may be plain JSON or SSE ("data: {...}"); normalise to an object.
function Read-Body($resp) {
    $c = $resp.Content
    if ($c -is [byte[]]) { $c = [Text.Encoding]::UTF8.GetString($c) }
    $data = @($c -split "`n" | Where-Object { $_ -like "data: *" })
    if ($data.Count -gt 0) { $c = $data[-1].Substring(6) }
    return ($c | ConvertFrom-Json)
}

function Send($body) {
    return Invoke-WebRequest -Uri $Url -Method Post -Headers $Headers -ContentType "application/json" -Body $body -UseBasicParsing
}

try {
    Write-Host "1/3 initialize -> $Url"
    $init = Send '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-06-18","capabilities":{},"clientInfo":{"name":"evendo-smoke-test","version":"1.0"}}}'
    $sid = $init.Headers["Mcp-Session-Id"]
    if ($sid) { $Headers["Mcp-Session-Id"] = [string]($sid | Select-Object -First 1) }
    $r = (Read-Body $init).result
    Write-Host ("   server: {0} {1} | protocol: {2}" -f $r.serverInfo.name, $r.serverInfo.version, $r.protocolVersion)

    Send '{"jsonrpc":"2.0","method":"notifications/initialized"}' | Out-Null

    Write-Host "2/3 tools/list"
    $tools = (Read-Body (Send '{"jsonrpc":"2.0","id":2,"method":"tools/list"}')).result.tools
    $expected = "resolve_place","find_venues","search_venues","list_subareas","get_venue","get_venues"
    $noTitle = 0
    foreach ($t in $tools) {
        $title = $t.title
        if (-not $title) { $title = $t.annotations.title }
        if (-not $title) { $title = "MISSING"; $noTitle++ }
        Write-Host ("   {0,-15} title={1,-16} readOnly={2}" -f $t.name, $title, $t.annotations.readOnlyHint)
    }
    $missing = $expected | Where-Object { $tools.name -notcontains $_ }
    if ($missing) { Write-Host "   FAIL: missing tools $($missing -join ', ')" } else { Write-Host "   OK: all six tools present" }
    if ($noTitle -gt 0) { Write-Host "   WARN: $noTitle tool(s) have no title (required by Claude connectors directory)" }

    Write-Host "3/3 tools/call resolve_place(Madrid)"
    $call = Read-Body (Send '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"resolve_place","arguments":{"name":"Madrid","place_type":"Cities","country_code":"ES"}}}')
    if ($call.result -and -not $call.result.isError) { Write-Host "   OK" } else { Write-Host "   FAIL: $($call | ConvertTo-Json -Depth 6 -Compress)" }
}
catch {
    Write-Host "ERROR: $($_.Exception.Message)"
}
