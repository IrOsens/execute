Stop-Process -Name "Signal"
Start-Sleep -Milliseconds 2000
Start-Process "$env:LocalAppData\Programs\signal-desktop\Uninstall Signal.exe"
