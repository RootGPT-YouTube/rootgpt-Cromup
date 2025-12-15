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

REM ===Verifica aggiornamenti tramite ETag===
echo Controllo aggiornamenti disponibili...

REM Ottieni l'ETag corrente dal server GitHub
for /f "tokens=*" %%i in ('powershell -Command "(Invoke-WebRequest -Uri 'https://github.com/uazo/cromite/releases/latest/download/chrome-win.zip' -Method Head -UseBasicParsing).Headers.ETag"') do set NEW_ETAG=%%i

REM Leggi l'ETag salvato localmente
set OLD_ETAG=
if exist "C:\Cromite\etag.txt" (
    set /p OLD_ETAG=<"C:\Cromite\etag.txt"
)

REM Confronta gli ETag
if "!NEW_ETAG!"=="!OLD_ETAG!" (
    echo Nessun aggiornamento disponibile. Cromite e gia aggiornato.
    echo ETag corrente: !OLD_ETAG!
    goto skip_download
) else (
    echo Nuovo aggiornamento disponibile!
    echo ETag vecchio: !OLD_ETAG!
    echo ETag nuovo: !NEW_ETAG!
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

REM ===Salva il nuovo ETag===
echo !NEW_ETAG!>"C:\Cromite\etag.txt"
echo ETag salvato per controlli futuri.

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

:skip_download

REM ===Creazione collegamento nel menu start===
echo Verifica collegamento nel menu Start...

REM Controlla se il collegamento esiste già
if exist "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Cromite.lnk" (
    echo Collegamento gia presente nel menu Start.
) else (
    echo Creazione del collegamento nel menu Start...
    powershell -Command "$s = \"%APPDATA%\Microsoft\Windows\Start Menu\Programs\Cromite.lnk\"; $t = \"C:\Cromite\chrome-win\cromite.exe\"; $ws = New-Object -ComObject WScript.Shell; $lnk = $ws.CreateShortcut($s); $lnk.TargetPath = $t; $lnk.Save()"
    echo Collegamento creato con successo.
)

REM ===Messaggio di chiusura===
echo.
echo ================================================
echo Esecuzione script terminata con successo!
echo ================================================
echo.
pause
exit /b