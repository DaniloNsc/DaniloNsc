param(
    [Parameter(Mandatory = $false)]
    [string]$RamMapPath = "C:\Tools\RAMMap\RAMMap.exe",

    [Parameter(Mandatory = $false)]
    [ValidateRange(5, 86400)]
    [int]$IntervalSeconds = 300,

    [Parameter(Mandatory = $false)]
    [switch]$RunOnce
)

$ErrorActionPreference = "Stop"

function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO", "WARN", "ERROR")]
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Level] $Message"
}

if (-not (Test-Path -Path $RamMapPath -PathType Leaf)) {
    Write-Log -Level "ERROR" -Message "RAMMap não encontrado em: $RamMapPath"
    exit 1
}

Write-Log -Message "Iniciando RAM Optimizer Windows"
Write-Log -Message "Executável: $RamMapPath"
Write-Log -Message "Intervalo: $IntervalSeconds segundos"
Write-Log -Message "Modo RunOnce: $RunOnce"

while ($true) {
    try {
        Start-Process -FilePath $RamMapPath -ErrorAction Stop | Out-Null
        Write-Log -Message "RAMMap executado com sucesso"
    }
    catch {
        Write-Log -Level "ERROR" -Message "Falha ao executar RAMMap: $($_.Exception.Message)"
    }

    if ($RunOnce) {
        Write-Log -Message "Execução única concluída. Encerrando script."
        break
    }

    Start-Sleep -Seconds $IntervalSeconds
}
