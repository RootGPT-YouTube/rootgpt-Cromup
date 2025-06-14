#!/bin/bash

# Variabili aggiornate
APP_NAME="Cromite"
EXEC_PATH="$HOME/Cromite/chrome"
ICON_URL="https://camo.githubusercontent.com/6b4ee03be91712db2d81b603a1bb83553e97b66fa49443bf27b641089ea51696/68747470733a2f2f7777772e63726f6d6974652e6f72672f6170705f69636f6e2e706e67"
ICON_PATH="$HOME/Cromite/cromite_icon.png"
DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME}.desktop"
DESKTOP_FILE2="$HOME/.local/share/applications/${APP_NAME}.desktop"

# Scaricare l'icona (senza creare la cartella)
curl -o "$ICON_PATH" "$ICON_URL"

# Creazione del file .desktop
echo "[Desktop Entry]
Comment=Take back your browser
Exec=$HOME/Cromite/cromite
GenericName=Browser
Icon=$HOME/Cromite/cromite_icon.png
Name=Cromite
NoDisplay=false
Path=
StartupNotify=true
Terminal=false
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=
Categories=Network;WebBrowser;
" | sudo tee "$DESKTOP_FILE"

echo "[Desktop Entry]
Comment=Take back your browser
Exec=$HOME/Cromite/cromite
GenericName=Browser
Icon=$HOME/Cromite/cromite_icon.png
Name=Cromite
NoDisplay=false
Path=
StartupNotify=true
Terminal=false
TerminalOptions=
Type=Application
X-KDE-SubstituteUID=false
X-KDE-Username=
Categories=Network;WebBrowser;
" | sudo tee "$DESKTOP_FILE2"

# Rendere il file eseguibile
# sudo chmod a+x "$DESKTOP_FILE"

# Rinominare l'eseguibile chrome in cromite
sudo mv ~/Cromite/chrome ~/Cromite/cromite

echo -e "\e[1;32mCollegamento creato con successo in $DESKTOP_FILE\e[0m"
echo -e "\e[1;32mIcona scaricata e salvata in $ICON_PATH\e[0m"
echo -e "\e[1;32mPremere un tasto per terminare lo script e iniziare a usare Cromite Browser!\e[0m"
echo -e "\e[1;32mPS: bug conosciuti: in KDE l'icona nel menù va creata con l'Editor del menù (kmenuedit).\e[0m"
read
