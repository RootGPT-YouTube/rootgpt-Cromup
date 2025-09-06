@echo off
setlocal enabledelayedexpansion

REM ===Chiusura di Cromite.exe===
taskkill /IM cromite.exe /F >nul 2>&1

REM ===Creazione di C:\Cromite se necessario===
echo Verifica della cartella C:\Cromite...
if not exist "C:\Cromite" (
    echo La cartella non esiste. Creazione in corso...
    mkdir "C:\Cromite"
    if errorlevel 1 (
        echo Errore nella creazione della cartella.
	pause
        exit /b
    )
)

REM ===Cancellazione file .manifest===
echo Controllo dei file .manifest...
dir /b "C:\Cromite\chrome-win\*.manifest" >nul 2>&1
if errorlevel 1 (
    echo Nessun file .manifest presente.
) else (
    echo Cancellazione dei file .manifest...
    del /Q "C:\Cromite\chrome-win\*.manifest"
)

REM ===Download con Progress Bar===
echo Download dell'aggiornamento di Cromite...
powershell -Command "Import-Module BitsTransfer; Start-BitsTransfer -Source 'https://github.com/uazo/cromite/releases/latest/download/chrome-win.zip' -Destination 'C:\Cromite\chrome-win.zip'"
if exist "C:\Cromite\chrome-win.zip" (
    echo Download completato con successo.
) else (
    echo Errore nel download del file.
    pause
    exit /b
)

REM ===Decompressione===
echo Applicazione degli aggiornamenti del Browser Cromite in corso...
powershell -Command "Expand-Archive -Path 'C:\Cromite\chrome-win.zip' -DestinationPath 'C:\Cromite\' -Force"
if errorlevel 1 (
    echo Errore nella decompressione dell'archivio.
    pause
    exit /b
)

REM ===Modifica dei permessi===
echo Modifica dei permessi di esecuzione...
powershell -Command "Set-ExecutionPolicy -Scope Process -ExecutionPolicy Unrestricted"
if errorlevel 1 (
    echo Errore nella modifica dei permessi.
    pause
    exit /b
)

REM ===Pulizia===
echo Pulizia di file ridondanti...
del "C:\Cromite\chrome-win.zip"
if exist "C:\Cromite\chrome-win.zip" (
    echo Errore nella cancellazione del file zip.
    pause
    exit /b
)

REM ===Rinomina del file eseguibile===
echo Rinomina del file chrome.exe in cromite.exe...
if exist "C:\Cromite\chrome-win\cromite.exe" del "C:\Cromite\chrome-win\cromite.exe"
ren "C:\Cromite\chrome-win\chrome.exe" "cromite.exe"
if errorlevel 1 (
    echo Errore nella rinomina del file eseguibile.
    pause
    exit /b
)

REM ===Download Icona personalizzata===
echo Download dell'icona personalizzata...
powershell -Command "(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/RootGPT-YouTube/rootgpt-Cromup/refs/heads/main/cromite_icon.ico', 'C:\Cromite\chrome-win\cromite_icon.ico')"
if not exist "C:\Cromite\chrome-win\cromite_icon.ico" (
    echo Errore nel download dell'icona.
    pause
    exit /b
)

REM ===Creazione collegamento nel menu start===
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

REM ===Messaggio di chiusura===
echo Esecuzione script terminata con successo.
pause
