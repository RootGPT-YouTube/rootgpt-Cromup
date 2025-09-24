#!/bin/bash

# == VARIABILI ==
FILE_URL="https://github.com/uazo/cromite/releases/latest/download/chrome-lin64.tar.gz"
FILE_NAME="chrome-lin64.tar.gz"
CROMITE_DIR="/home/$(logname)/Cromite"
LOCAL_FILE="$CROMITE_DIR/cromite"
TMP_FILE="/tmp/$FILE_NAME"
USER_ID=$(id -u $(logname))
DISPLAY=":0"
DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus"

# == CONTROLLO VERSIONE ==
remote_date=$(curl -sI "$FILE_URL" | grep -i '^Last-Modified:' | cut -d' ' -f2-)
remote_epoch=$(date -d "$remote_date" +%s)

if [ -f "$LOCAL_FILE" ]; then
    local_epoch=$(stat -c %Y "$LOCAL_FILE")
else
    echo "File locale non trovato, procedo con il download."
    local_epoch=0
fi

# == CONFRONTO ==
if [ "$remote_epoch" -gt "$local_epoch" ]; then
    echo "Aggiornamento disponibile. Scarico e installo..."
    curl -L --progress-bar -o "$TMP_FILE" "$FILE_URL" || {
        echo "Errore nel download!"
        sudo -u $(logname) DISPLAY=$DISPLAY DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
        notify-send -u critical -i dialog-error "Cromite update fallito" "Errore nel download dell'archivio."
        exit 1
    }

    tar -xzf "$TMP_FILE" -C "$CROMITE_DIR" || {
        echo "Errore nell'estrazione!"
        sudo -u $(logname) DISPLAY=$DISPLAY DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
        notify-send -u critical -i dialog-error "Cromite update fallito" "Errore nell'estrazione dell'archivio."
        exit 1
    }

    rm "$TMP_FILE"
    echo "Aggiornamento completato."
    sudo -u $(logname) DISPLAY=$DISPLAY DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS \
    notify-send -u normal -i software-update-available "Cromite aggiornato" "È stato installato un nuovo aggiornamento."
else
    echo "Nessun aggiornamento necessario."
fi
