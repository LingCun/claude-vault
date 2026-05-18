#requires -Version 5.0
<#
.SYNOPSIS
  Claude Desktop 설정 파일에 obsidian MCP 서버(SSE)를 등록합니다.
#>

$ErrorActionPreference = 'Stop'

$configPath = Join-Path $env:APPDATA 'Claude\claude_desktop_config.json'
Write-Host "설정 파일 경로: $configPath"

if (Test-Path $configPath) {
    $raw = Get-Content $configPath -Raw -Encoding UTF8
    if ([string]::IsNullOrWhiteSpace($raw)) {
        $config = [pscustomobject]@{}
    } else {
        $config = $raw | ConvertFrom-Json
    }
    $backupPath = "$configPath.bak"
    Copy-Item $configPath $backupPath -Force
    Write-Host "백업 생성: $backupPath"
} else {
    Write-Host "기존 설정 파일이 없습니다. 새로 만듭니다."
    $configDir = Split-Path $configPath -Parent
    if (-not (Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    }
    $config = [pscustomobject]@{}
}

if (-not ($config.PSObject.Properties.Name -contains 'mcpServers')) {
    $config | Add-Member -NotePropertyName 'mcpServers' -NotePropertyValue ([pscustomobject]@{}) -Force
}

$obsidianEntry = [pscustomobject]@{
    type = 'sse'
    url  = 'http://localhost:22360/sse'
}

if ($config.mcpServers.PSObject.Properties.Name -contains 'obsidian') {
    $config.mcpServers.obsidian = $obsidianEntry
    Write-Host "기존 'obsidian' 항목을 덮어썼습니다."
} else {
    $config.mcpServers | Add-Member -NotePropertyName 'obsidian' -NotePropertyValue $obsidianEntry -Force
    Write-Host "'obsidian' 항목을 새로 추가했습니다."
}

$json = $config | ConvertTo-Json -Depth 10
[System.IO.File]::WriteAllText($configPath, $json, [System.Text.UTF8Encoding]::new($false))

Write-Host ""
Write-Host "완료. 현재 설정 내용:"
Get-Content $configPath -Raw -Encoding UTF8 | Write-Host

Write-Host ""
Write-Host "다음 단계:"
Write-Host "  1) Claude Desktop 을 완전히 종료 (시스템 트레이 아이콘 포함)"
Write-Host "  2) Obsidian 실행 후 C:\claude\vault 폴더를 Vault 로 열기"
Write-Host "  3) 설정 - 커뮤니티 플러그인 - 제한 모드 해제 - 'Claude Code MCP' 활성화"
Write-Host "  4) Claude Desktop 다시 실행"
