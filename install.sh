#!/usr/bin/env bash
#set -euo pipefail

echo -e "\e[1;32mCreazione e installazione del comando cromup...\e[0m"
sleep 3
sudo chmod a+x ~/rootgpt-Cromup/cromup
sudo cp ~/rootgpt-Cromup/cromup /usr/local/bin/
echo -e "\e[1;32mSto per avviare cromup per la prima volta.\e[0m"
sleep 3
echo -e "\e[1;32mcromup è il comando da terminale necessario per installare e aggiornare Cromite Browser.\e[0m"
sleep 5
echo -e "\e[1;32mDa ora in poi, quando vorrai aggiornare Cromite, ti basterà lanciare cromup da terminale.\e[0m"
sleep 5
echo -e "\e[1;32mL'installazione di Cromite avverrà tra 5 secondi tramite cromup. Premere CTRL+c per interrompere la procedura...\e[0m"
cromup
echo -e "\e[1;32mFine installazione di Cromite Browser e di cromup. Chiusura in 5 secondi...\e[0m"
sleep 5
