@echo off

echo Verifica della cartella C:\Cromite...
if not exist "C:\Cromite" (
    echo La cartella non esiste. Creazione in corso...
    mkdir "C:\Cromite"
)

echo Cancellazione dei files .manifest...
del /Q "C:\Cromite\chrome-win\*.manifest"

echo Download dell'aggiornamento di Cromite...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://release-assets.githubusercontent.com/github-production-release-asset/257841809/80431b4c-8381-458f-b4b0-4264c2a97faa?sp=r&sv=2018-11-09&sr=b&spr=https&se=2025-09-02T10%3A33%3A56Z&rscd=attachment%3B+filename%3Dchrome-win.zip&rsct=application%2Foctet-stream&skoid=96c2d410-5711-43a1-aedd-ab1947aa7ab0&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skt=2025-09-02T09%3A32%3A58Z&ske=2025-09-02T10%3A33%3A56Z&sks=b&skv=2018-11-09&sig=CtEoJz0qQU57ceJMGSciYo1zfMw1A0zud1cJyWjkIdY%3D&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmVsZWFzZS1hc3NldHMuZ2l0aHVidXNlcmNvbnRlbnQuY29tIiwia2V5Ijoia2V5MSIsImV4cCI6MTc1NjgwNjI0NywibmJmIjoxNzU2ODA1OTQ3LCJwYXRoIjoicmVsZWFzZWFzc2V0cHJvZHVjdGlvbi5ibG9iLmNvcmUud2luZG93cy5uZXQifQ.fAe1WCGbMhg0slY4tacuoCQ-h2qU5PA0lzU-mCAI4IA&response-content-disposition=attachment%3B%20filename%3Dchrome-win.zip&response-content-type=application%2Foctet-stream', 'C:\Cromite\chrome-win.zip')"

echo Applicazione degli aggiornamenti del Browser Cromite in corso...
powershell -Command "Expand-Archive -Path 'C:\Cromite\chrome-win.zip' -DestinationPath 'C:\Cromite\' -Force"

echo Modifica dei permessi di esecuzione...
powershell -Command "Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted"

echo Pulizia di file ridondanti...
del "C:\Cromite\chrome-win.zip"

echo Rinomina del file chrome.exe in cromite.exe...
if exist "C:\Cromite\chrome-win\cromite.exe" del "C:\Cromite\chrome-win\cromite.exe"
ren "C:\Cromite\chrome-win\chrome.exe" "cromite.exe"

echo Download dell'icona personalizzata...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/RootGPT-YouTube/rootgpt-Cromup/refs/heads/main/cromite_icon.ico', 'C:\Cromite\chrome-win\cromite_icon.ico')"

echo Rimozione del collegamento esistente, se presente...
powershell -Command "if (Test-Path \"$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Cromite.lnk\") { Remove-Item \"$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Cromite.lnk\" }"

echo Creazione del collegamento nel menu Start con icona personalizzata...
powershell -Command ^
"$s = \"$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Cromite.lnk\"; ^
$t = \"C:\Cromite\chrome-win\cromite.exe\"; ^
$i = \"C:\Cromite\chrome-win\cromite_icon.ico\"; ^
$ws = New-Object -ComObject WScript.Shell; ^
$lnk = $ws.CreateShortcut($s); ^
$lnk.TargetPath = $t; ^
$lnk.IconLocation = $i; ^
$lnk.Save()"

echo Esecuzione script terminata.

pause
