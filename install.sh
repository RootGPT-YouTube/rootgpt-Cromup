#!/bin/bash
echo -e "\e[1;32mInstallazione cromup, è possibile che venga richiesta la password utente o di root...\e[0m"
sudo chmod a+x cromup
sudo cp cromup /usr/local/bin/
echo -e "\e[1;32mSto per avviare cromup per la prima volta.\e[0m"
echo -e "\e[1;32mcromup è il comando da terminale necessario per installare e aggiornare Cromite Browser.\e[0m"
echo -e "\e[1;32mDa ora in poi, quando vorrai aggiornare Cromite, ti basterà lanciare cromup da terminale.\e[0m"
echo -e "\e[1;32mPremere un tasto per installare Cromite adesso tramite cromup oppure CTRL+c per interrompere la procedura...\e[0m"
read
cromup
echo -e "\e[1;32mCreazione collegamento nel menù delle applicazioni...\e[0m"
sudo chmod a+x link_menu.sh
./link_menu.sh
