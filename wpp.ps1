$client = new-object System.Net.WebClient
$client.DownloadFile("https://cdn.discordapp.com/attachments/1077896000225673287/1150573888552579103/wpp.png", "wpp.jpg")
reg add "HKCU\Control Panel\Desktop" /v WallPaper /d "%USERPROFILE%\wpp.jpg" /f
RUNDLL32.EXE USER32.DLL,UpdatePerUserSystemParameters ,1 ,True
exit
