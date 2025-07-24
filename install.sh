#!/usr/bin/env bash
#set -euo pipefail

echo -e "\e[1;32mCreazione e installazione del comando cromup...\e[0m"
sudo chmod a+x ~/rootgpt-Cromup/cromup
sudo cp ~/rootgpt-Cromup/cromup /usr/local/bin/
echo -e "\e[1;32mSto per avviare cromup per la prima volta.\e[0m"
echo -e "\e[1;32mcromup è il comando da terminale necessario per installare e aggiornare Cromite Browser.\e[0m"
echo -e "\e[1;32mDa ora in poi, quando vorrai aggiornare Cromite, ti basterà lanciare cromup da terminale.\e[0m"
echo -e "\e[1;32mPremere un tasto per installare Cromite adesso tramite cromup oppure CTRL+c per interrompere la procedura...\e[0m"
read
cromup

# Se usare link_menu.sh decommentare le due righe sotto
# sudo chmod a+x link_menu.sh
# ./link_menu.sh

# --- Creazione del link nel menù ---
# --- Dipendenze da controllare ---
deps=(curl gtk-update-icon-cache kbuildsycoca6)

# Rileva il package manager disponibile
detect_pm() {
  if   command -v apt-get &> /dev/null; then echo "apt"
  elif command -v dnf     &> /dev/null; then echo "dnf"
  elif command -v pacman  &> /dev/null; then echo "pacman"
  elif command -v zypper  &> /dev/null; then echo "zypper"
  else echo "none"; fi
}

# Installa pacchetti richiesti
install_pkgs() {
  local pm=$1; shift
  case "$pm" in
    apt)    sudo apt-get update && sudo apt-get install -y "$@";;
    dnf)    sudo dnf install -y "$@";;
    pacman) sudo pacman -Sy --noconfirm "$@";;
    zypper) sudo zypper install -y "$@";;
    *)      echo "❌ Nessun package manager supportato. Installa manualmente: $*"; exit 1;;
  esac
}

# Controllo e installazione dipendenze
pm=$(detect_pm)
missing=()
for cmd in "${deps[@]}"; do
  if ! command -v "$cmd" &> /dev/null; then
    missing+=("$cmd")
  fi
done

if [ "${#missing[@]}" -gt 0 ]; then
  echo "⚙️  Dipendenze mancanti: ${missing[*]}"
  echo "🛠  Installazione in corso con $pm..."
  install_pkgs "$pm" "${missing[@]}"
  echo "✅ Dipendenze installate."
else
  echo "✅ Tutte le dipendenze soddisfatte."
fi

# --- Variabili ---
APP_NAME="Cromite"
EXEC_PATH="$HOME/Cromite/cromite"
ICON_URL="https://camo.githubusercontent.com/6b4ee03be91712db2d81b603a1bb83553e97b66fa49443bf27b641089ea51696/68747470733a2f2f7777772e63726f6d6974652e6f72672f6170705f69636f6e2e706e67"
ICON_NAME="cromite"
ICON_DEST="/usr/share/icons/hicolor/192x192/apps/${ICON_NAME}.png"
DESKTOP_LOCAL="$HOME/.local/share/applications/${APP_NAME}.desktop"
DESKTOP_GLOBAL="/usr/share/applications/${APP_NAME}.desktop"
KDE_MENU="$HOME/.config/menus/applications-kmenuedit.menu"
WORKING_DIR="$HOME/rootgpt-Cromup"

# Eliminazione eventuali Cromite.desktop precedenti
echo -e "\e[1;32m✅ Tentativo di rimozione di collegamenti nel menù creati da precedenti installazioni...\e[0m"
sudo rm -f "$DESKTOP_LOCAL"
sudo rm -f "$DESKTOP_GLOBAL"

echo -e "\e[1;32mCreazione collegamento nel menù delle applicazioni...\e[0m"

# Scarica icona
sudo curl -fsSL -o "$ICON_DEST" "$ICON_URL"
sudo gtk-update-icon-cache /usr/share/icons/hicolor

# Crea desktop entry
mkdir -p "$(dirname "$DESKTOP_LOCAL")"
cat > "$DESKTOP_LOCAL" <<EOF
[Desktop Entry]
Version=1.0
Name=${APP_NAME}
GenericName=Web Browser
Comment=Take back your browser
TryExec=${EXEC_PATH}
Exec=${EXEC_PATH}
Icon=${ICON_NAME}
Terminal=false
Type=Application
Categories=Network;WebBrowser;
StartupWMClass=Chromium-browser
MimeType=x-scheme-handler/http;x-scheme-handler/https;
Keywords=browser;internet;privacy;secure;${APP_NAME};
NoDisplay=false
EOF

# Copia il file .desktop nella directory globale
sudo cp "$DESKTOP_LOCAL" "$DESKTOP_GLOBAL"

# Se siamo su KDE, rimuoviamo menu personalizzati e rigeneriamo la cache
if [[ "${XDG_CURRENT_DESKTOP:-}" = KDE ]]; then
  if [ -f "$KDE_MENU" ]; then
    echo "🧹 Rimuovo override utente da KDE menu..."
    rm -f "$KDE_MENU"
  fi
  echo "🔄 Ricostruisco cache SYCOCA..."
  rm -rf ~/.cache/*plasma* ~/.cache/kactivitymanager-statsrc
  kbuildsycoca6 --noincremental
  echo "✅ Cache KDE aggiornata."
fi

#Eliminazione cartella di lavoro
echo -e "\e[1;32mEliminazione cartella di lavoro...\e[0m"
sudo rm -fr "$WORKING_DIR"

# Output finale
echo -e "\e[1;32m✅ Cromite installato correttamente!\e[0m"
echo -e "  • Icona salvata in: $ICON_DEST"
echo -e "  • Desktop entry (utente): $DESKTOP_LOCAL"
echo -e "  • Desktop entry (globale): $DESKTOP_GLOBAL"
echo -e "\e[1;33mℹ️  Se l’icona non dovesse comparire subito nel menu, provare a fare logout o a riavviare il DE o il PC.\e[0m"
echo -e "\e[1;32mPremi INVIO per uscire…\e[0m"
read -r
