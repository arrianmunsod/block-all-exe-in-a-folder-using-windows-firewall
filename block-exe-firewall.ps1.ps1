# ============================================================
# Block all EXE files in a folder and its subfolders
# Windows 10 / Windows 11
# ============================================================


# ============================================================
# SELF-LAUNCH AS ADMINISTRATOR
# Allows the .ps1 file to be double-clicked directly.
# ============================================================

$IsAdmin = ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator
)

if (-not $IsAdmin) {

    Start-Process powershell.exe `
        -Verb RunAs `
        -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""

    exit
}


# ============================================================
# MAIN LOOP
# ============================================================

while ($true) {

    Write-Host ""
    Write-Host "============================================================"
    Write-Host "        BLOCK EXE FILES USING WINDOWS FIREWALL"
    Write-Host "============================================================"
    Write-Host ""

    # Ask for folder path
    $TargetFolder = Read-Host "Enter the folder path"


    # Remove quotation marks if the user pasted a path like:
    # "C:\Program Files\Example"
    $TargetFolder = $TargetFolder.Trim('"')


    # ========================================================
    # CHECK TARGET FOLDER
    # ========================================================

    if (-not (Test-Path -LiteralPath $TargetFolder -PathType Container)) {

        Write-Host ""
        Write-Host "ERROR: Folder does not exist:" -ForegroundColor Red
        Write-Host $TargetFolder -ForegroundColor Yellow
        Write-Host ""

        continue
    }


    # ========================================================
    # FIND EXE FILES
    # ========================================================

    Write-Host ""
    Write-Host "Searching for EXE files..." -ForegroundColor Cyan
    Write-Host "Folder: $TargetFolder"
    Write-Host ""


    $ExeFiles = Get-ChildItem `
        -LiteralPath $TargetFolder `
        -Filter "*.exe" `
        -File `
        -Recurse `
        -ErrorAction SilentlyContinue


    if ($ExeFiles.Count -eq 0) {

        Write-Host "No EXE files were found." -ForegroundColor Yellow
        continue
    }


    Write-Host "Found $($ExeFiles.Count) EXE file(s)." -ForegroundColor Green
    Write-Host ""


    # ========================================================
    # CREATE FIREWALL RULES
    # ========================================================

    $Created = 0
    $Skipped = 0


    foreach ($Exe in $ExeFiles) {

        $ExePath = $Exe.FullName


        # Create a deterministic rule name based on executable path
        $Hash = [System.BitConverter]::ToString(
            [System.Security.Cryptography.SHA256]::Create().ComputeHash(
                [System.Text.Encoding]::UTF8.GetBytes($ExePath)
            )
        ).Replace("-", "").Substring(0,16)


        $RuleName = "Block EXE - $($Exe.Name) [$Hash]"


        # Check whether the rule already exists
        $ExistingRule = Get-NetFirewallRule `
            -DisplayName $RuleName `
            -ErrorAction SilentlyContinue


        if ($ExistingRule) {

            Write-Host "[SKIP] $ExePath" -ForegroundColor DarkYellow
            $Skipped++
            continue
        }


        # Create outbound block rule
        New-NetFirewallRule `
            -DisplayName $RuleName `
            -Direction Outbound `
            -Program $ExePath `
            -Action Block `
            -Profile Any `
            -Enabled True `
            -Protocol Any `
            -Description "Blocks Internet/network access for $ExePath" `
            -ErrorAction Stop | Out-Null


        Write-Host "[BLOCKED] $ExePath" -ForegroundColor Green

        $Created++
    }


    # ========================================================
    # FINISHED
    # ========================================================

    Write-Host ""
    Write-Host "============================================================"
    Write-Host "Finished."
    Write-Host "Folder           : $TargetFolder"
    Write-Host "EXE files found  : $($ExeFiles.Count)"
    Write-Host "Rules created    : $Created"
    Write-Host "Rules skipped    : $Skipped"
    Write-Host "============================================================"

    # Loop automatically returns to the folder prompt
}