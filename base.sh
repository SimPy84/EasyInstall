#!/bin/sh

@ECHO OFF

# Copyright (c) Vite Aerea
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

dialog --backtitle "Arch Linux Easy Install" --title " Bienvenu " \
--yes-label "Continuer" --no-label "Sortir" --yesno "
Bienvenu dans le script d'installation d'Arch Linux façon Vite Aerea.

Ce Script propose une installation automatisée d'Arch Linux." 12 60

if [ "$?" = "1" ]
then
  dialog --backtitle "Arch Linux Easy Install" --title " Au revoir " \
  --sleep 2 --infobox "\n\nFin de l'installation..." 8 40
  clear
  exit 0
fi

# Test de la connexion internet
dialog --backtitle "Arch Linux Easy Install" --title " Test de la connexion internet " \
--sleep 2 --infobox "\nVeuillez patienter pendant le test de la connection internet..." 7 50

if [[ -z $(command -v wget) ]]; then
    dialog --backtitle "Arch Linux Easy Install" --title " Erreur " --sleep 3 --infobox "\n\n Wget est introuvable\n\n Fin de l'installation..." 9 40
    exit 0
fi
# Test de la connection en téléchargeant un fichier
if ! wget -O - ftp://ftp.archlinux.org/lastsync &> /dev/null
then
    dialog --backtitle "Arch Linux Easy Install" --title " Erreur " --sleep 3 --infobox "\n\n Connexion indisponible\n\n Fin de l'installation..." 9 40
    exit 0	
fi
dialog --backtitle "Arch Linux Easy Install" --title " Test de la connexion internet " \
--sleep 2 --infobox "\nLa connection internet est fonctionnelle !" 7 50 

# Localisation linguistique
dialog --backtitle "Arch Linux Easy Install" --title " Paramètres linguistiques " \
--sleep 2 --colors --infobox "\n Localisation linguistique :\n   \Z1- Langue du clavier\n   - Langue système" 7 40

dialog --backtitle "Arch Linux Easy Install" --title " Paramètres linguistiques " \
--sleep 1 --colors --infobox "\n Localisation linguistique :\n   \Z4-> Langue du clavier\n   \Z1- Langue système" 7 40
loadkeys be-latin1

dialog --backtitle "Arch Linux Easy Install" --title " Paramètres linguistiques " \
--sleep 1 --colors --infobox "\n Localisation linguistique :\n   \Z2+ Langue du clavier\n   \Z4-> Langue système" 7 40
sed -i '/fr_FR\.UTF-8/ s/^#//' /etc/locale.gen
locale-gen
export LANG=fr_FR.UTF-8

dialog --backtitle "Arch Linux Easy Install" --title " Paramètres linguistiques " \
--sleep 2 --colors --infobox "\n Localisation linguistique :\n   \Z2+ Langue du clavier\n   \Z2+ Langue système" 7 40

# Création du système de fichiers
DISK='/dev/sda'
 
dialog --backtitle "Arch Linux Easy Install" --title " Système de fichiers " \
--sleep 2 --colors --infobox "\n Formatage du disque dur :\n   \Z1- Création de la table de partition (MBR)\n   - Partionnement\n   - Formatge\n   - Montage des partitions" 9 60

dialog --backtitle "Arch Linux Easy Install" --title " Système de fichiers " \
--sleep 1 --colors --infobox "\n Formatage du disque dur :\n   \Z4-> Création de la table de partition (MBR)\n\Z1   - Partionnement\n   - Formatge\n   - Montage des partitions" 9 60
sgdisk --zap-all $DISK
parted $DISK mklabel msdos

dialog --backtitle "Arch Linux Easy Install" --title " Système de fichiers " \
--sleep 1 --colors --infobox "\n Formatage du disque dur :\n   \Z2+ Création de la table de partition (MBR)\n\Z4   -> Partionnement\n\Z1   - Formatge\n   - Montage des partitions" 9 60
parted $DISK unit MB mkpart primary linux-swap 1 1024
parted -- $DISK unit MB mkpart primary ext4 1024 -0
parted $DISK set 2 boot on

dialog --backtitle "Arch Linux Easy Install" --title " Système de fichiers " \
--sleep 1 --colors --infobox "\n Formatage du disque dur :\n   \Z2+ Création de la table de partition (MBR)\n   + Partionnement\n\Z4   -> Formatge\n\Z1   - Montage des partitions" 9 60
mkfs.ext4 /dev/sda2
mkswap /dev/sda1
swapon /dev/sda1

dialog --backtitle "Arch Linux Easy Install" --title " Système de fichiers " \
--sleep 1 --colors --infobox "\n Formatage du disque dur :\n   \Z2+ Création de la table de partition (MBR)\n   + Partionnement\n   + Formatge\n\Z4   -> Montage des partitions" 9 60
mount /dev/sda2 /mnt

dialog --backtitle "Arch Linux Easy Install" --title " Système de fichiers " \
--sleep 2 --colors --infobox "\n Formatage du disque dur :\n   \Z2+ Création de la table de partition (MBR)\n   + Partionnement\n   + Formatge\n   + Montage des partitions" 9 60

# Sélection du mirroire
dialog --backtitle "Arch Linux Easy Install" --title " Sélection du mirroire " \
--sleep 2 --infobox "\n\n   Test de la connectivité des serveurs en cours,\n     Veuillez patienter." 7 60
cp /etc/pacman.d/mirrolist /etc/pacman.d/mirrolist.old
rankmirrors --generate --method rank --country Belgium,Germany,France

# Synchronisation des dépots
dialog --backtitle "Arch Linux Easy Install" --title " Mise à jour des dépots " \
--sleep 2 --infobox "\n\n   Mise à jour des dépots en cours,\n     Veuillez patienter." 7 60
pacman -Sy

# Installation du système de base
dialog --backtitle "Arch Linux Easy Install" --title " Installation du système de base " \
--sleep 2 --infobox "\n\n   Le système de base va être installé maintenant." 7 60
pacstrap -i /mnt base base-devel
genfstab -U -p /mnt >> /mnt/etc/fstab
cd /mnt/root
wget https://raw.githubusercontent.com/SimPy84/EasyInstall/master/config.sh
chmod a+x config.sh
cd

# Chroot
dialog --backtitle "Arch Linux Easy Install" --title " Chroot " \
--msgbox "
Fin de l'instalation de base. Le système va changer de
répertoire racine.

Pour continuer veuillez tapez la commande :
  # ./config.sh" 12 60

arch-chroot /mnt /bin/bash

# ••¤(`×[¤ Qεяε∂ ¤]×´)¤••
