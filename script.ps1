[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$RamMapPath = "C:\Tools\RAMMap\RAMMap.exe",

    [Parameter(Mandatory = $false)]
    [ValidateRange(5, 86400)]
    [int]$IntervalSeconds = 300,

    [Parameter(Mandatory = $false)]
    [switch]$RunOnce
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Write-Log {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message,

        [Parameter(Mandatory = $false)]
        [ValidateSet("INFO", "WARN", "ERROR")]
        [string]$Level = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] [$Level] $Message"
}

$resolvedRamMapPath = [System.IO.Path]::GetFullPath($RamMapPath)
$ramMapProcessName = [System.IO.Path]::GetFileNameWithoutExtension($resolvedRamMapPath)

if ([string]::IsNullOrWhiteSpace($ramMapProcessName)) {
    Write-Log -Level "ERROR" -Message "Nome do processo inválido para o caminho informado: $RamMapPath"
    exit 1
}

if (-not (Test-Path -Path $resolvedRamMapPath -PathType Leaf)) {
    Write-Log -Level "ERROR" -Message "RAMMap não encontrado em: $resolvedRamMapPath"
    exit 1
}

Write-Log -Message "Iniciando RAM Optimizer Windows"
Write-Log -Message "Executável: $resolvedRamMapPath"
Write-Log -Message "Intervalo: $IntervalSeconds segundos"
Write-Log -Message "Modo RunOnce: $RunOnce"

while ($true) {
    try {
        $existingProcess = Get-Process -Name $ramMapProcessName -ErrorAction SilentlyContinue

        if ($null -ne $existingProcess) {
            Write-Log -Level "WARN" -Message "$ramMapProcessName já está em execução. Novo ciclo será ignorado para evitar múltiplas instâncias."
        }
        else {
            Start-Process -FilePath $resolvedRamMapPath -ErrorAction Stop | Out-Null
            Write-Log -Message "RAMMap executado com sucesso"
        }
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
