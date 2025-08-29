@echo off

echo Verifica della cartella C:\Cromite...
if not exist "C:\Cromite" (
    echo La cartella non esiste. Creazione in corso...
    mkdir "C:\Cromite"
)

echo Cancellazione dei files .manifest...
del /Q "C:\Cromite\chrome-win\*.manifest"

echo Download dell'aggiornamento di Cromite...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://github.com/uazo/cromite/releases/latest/download/chrome-win.zip', 'C:\Cromite\chrome-win.zip')"

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