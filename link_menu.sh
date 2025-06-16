#!/bin/bash

# Variabili aggiornate
APP_NAME="Cromite"
EXEC_PATH="$HOME/Cromite/chrome"
ICON_URL="https://camo.githubusercontent.com/6b4ee03be91712db2d81b603a1bb83553e97b66fa49443bf27b641089ea51696/68747470733a2f2f7777772e63726f6d6974652e6f72672f6170705f69636f6e2e706e67"
ICON_PATH="$HOME/Cromite/cromite_icon.png"
DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME}.desktop"
DESKTOP_FILE2="/usr/share/applications/${APP_NAME}.desktop"

# Scaricare l'icona (senza creare la cartella)
curl -o "$ICON_PATH" "$ICON_URL"

# Creazione del file .desktop
echo "[Desktop Entry]
Version=1.0
Name=Cromite
Comment=Take back your browser
Exec=$HOME/Cromite/cromite
Icon=$HOME/Cromite/cromite_icon.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;
" | sudo tee "$DESKTOP_FILE"

# Rendere il file eseguibile
# sudo chmod a+x "$DESKTOP_FILE"

# Rinominare l'eseguibile chrome in cromite
sudo mv ~/Cromite/chrome ~/Cromite/cromite

echo -e "\e[1;32mCollegamento creato con successo in $DESKTOP_FILE\e[0m"
echo -e "\e[1;32mIcona scaricata e salvata in $ICON_PATH\e[0m"
echo -e "\e[1;32mPremere un tasto per terminare lo script e iniziare a usare Cromite Browser!\e[0m"
echo -e "\e[1;32mPS: bug conosciuti:\e[0m"
echo -e "\e[1;32m1. Sometimes, the icon in the menu must be created manually, I don't know why... However, the executable are in ~/Cromite/cromite;\e[0m"
echo -e "\e[1;32m2. In some DEs, the Chromium icon will appear instead of the Cromite one.\e[0m"
read
