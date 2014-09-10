#!/bin/sh

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
Suite de l'installation d'Arch Linux et configuration du nouveau système." 12 60

if [ "$?" = "1" ]
then
  dialog --backtitle "Arch Linux Easy Install" --title " Au revoir " \
  --sleep 2 --infobox "\n\nFin de l'installation..." 8 40
  clear
  exit 0
fi

# Localisation linguistique
dialog --backtitle "Arch Linux Easy Install" --title " Paramètres linguistiques " \
--sleep 2 --colors --infobox "\n Localisation linguistique :\n \Z1- Langue du clavier\n - Langue système\n - configuration console" 8 40

dialog --backtitle "Arch Linux Easy Install" --title " Paramètres linguistiques " \
--sleep 1 --colors --infobox "\n Localisation linguistique :\n \Z4-> Langue du clavier\n \Z1- Langue système\n - configuration console" 8 40
loadkeys be-latin1

dialog --backtitle "Arch Linux Easy Install" --title " Paramètres linguistiques " \
--sleep 1 --colors --infobox "\n Localisation linguistique :\n \Z2+ Langue du clavier\n \Z4-> Langue système\n \Z1- configuration console" 8 40
sed -i '/fr_FR\.UTF-8/ s/^#//' /etc/locale.gen
sed -i '/en_US\.UTF-8/ s/^#//' /etc/locale.gen
locale-gen
touch /etc/locale.conf
echo "# Enable UTF-8 with French settings." >> /etc/locale.conf
echo 'LANG="fr_FR.UTF-8"' >> /etc/locale.conf
echo "" >> /etc/locale.conf
echo "# Setting fallback locales" >> /etc/locale.conf
echo 'LANGUAGE="fr_FR:fr:en_US:en"' >> /etc/locale.conf
echo "" >> /etc/locale.conf
echo "# Keep the default sort order (e.g. files starting with a '.'" >> /etc/locale.conf
echo "# should appear at the start of a directory listing.)" >> /etc/locale.conf
echo 'LC_COLLATE="C"' >> /etc/locale.conf
export LANG=fr_FR.UTF-8

dialog --backtitle "Arch Linux Easy Install" --title " Paramètres linguistiques " \
--sleep 1 --colors --infobox "\n Localisation linguistique :\n \Z2+ Langue du clavier\n + Langue système\n \Z4-> configuration console" 8 40
touch /etc/vconsole.conf
echo "KEYMAP=be-latin1" >> /etc/vconsole.conf
echo "FONT=lat9w-16" >> /etc/vconsole.conf
echo "FONT_UNIMAP=lat9w" >> /etc/vconsole.conf

dialog --backtitle "Arch Linux Easy Install" --title " Paramètres linguistiques " \
--sleep 2 --colors --infobox "\n Localisation linguistique :\n \Z2+ Langue du clavier\n + Langue système\n + configuration console" 8 40

# Configuration des composants et processus système
dialog --backtitle "Arch Linux Easy Install" --title " Configuration système " \
--sleep 2 --colors --infobox "\n \Z1- Fuseau horaire et horloge\n - Connectivité\n - Kernel Linux" 8 40

dialog --backtitle "Arch Linux Easy Install" --title " Configuration système " \
--sleep 1 --colors --infobox "\n \Z4-> Fuseau horaire et horloge\n \Z1- Connectivité\n - Kernel Linux" 8 40
ln -s /usr/share/zoneinfo/Europe/Brussels /etc/localtime
hwclock --systohc --utc

dialog --backtitle "Arch Linux Easy Install" --title " Configuration système " \
--sleep 1 --colors --infobox "\n \Z2+ Fuseau horaire et horloge\n \Z4-> Connectivité\n \Z1- Kernel Linux" 8 40
#hostnamectl set-hostname ViteAerea.test
systemctl enable dhcpcd.service

dialog --backtitle "Arch Linux Easy Install" --title " Configuration système " \
--sleep 1 --colors --infobox "\n \Z2+ Fuseau horaire et horloge\n + Connectivité\n \Z4-> Kernel Linux" 8 40
mkinitcpio -p linux

dialog --backtitle "Arch Linux Easy Install" --title " Configuration système " \
--sleep 2 --colors --infobox "\n \Z2+ Fuseau horaire et horloge\n + Connectivité\n + Kernel Linux" 8 40

# Installation du bootloader
dialog --backtitle "Arch Linux Easy Install" --title " Bootloader " \
--sleep 2 -- colors --infobox "\n\n \Z1- Installation du bootloader\n - Configuration du bootloader" 7 40

dialog --backtitle "Arch Linux Easy Install" --title " Bootloader " \
--sleep 1 -- colors --infobox "\n\n \Z4-> Installation du bootloader\n \Z1- Configuration du bootloader" 7 40
pacman -S grub

dialog --backtitle "Arch Linux Easy Install" --title " Bootloader " \
--sleep 1 -- colors --infobox "\n\n \Z2+ Installation du bootloader\n \Z4-> Configuration du bootloader" 7 40
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

dialog --backtitle "Arch Linux Easy Install" --title " Bootloader " \
--sleep 2 -- colors --infobox "\n\n \Z2+ Installation du bootloader\n + Configuration du bootloader" 7 40

# Installation de paquets supplémentaires indispensables
dialog --backtitle "Arch Linux Easy Install" --title " CLI indispensables " \
--sleep 2 -- colors --infobox "\n\n \Z1- Installation des indispensables" 7 40

dialog --backtitle "Arch Linux Easy Install" --title " CLI indispensables " \
--sleep 1 -- colors --infobox "\n\n \Z4-> Installation des indispensables" 7 40
pacman -S vim mc gpm wget zsh git

dialog --backtitle "Arch Linux Easy Install" --title " CLI indispensables " \
--sleep 2 -- colors --infobox "\n\n \Z2+ Installation des indispensables" 7 40

# Installation de Yaourt
dialog --backtitle "Arch Linux Easy Install" --title " Yaourt " \
--sleep 2 -- colors --infobox "\n \Z1- Download des paquets\n - Installations des dépendances\n - Installaton de Yaourt" 8 40

dialog --backtitle "Arch Linux Easy Install" --title " Yaourt " \
--sleep 1 -- colors --infobox "\n \Z4-> Download des paquets\n \Z1- Installations des dépendances\n - Installaton de Yaourt" 8 40
curl -O https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
curl -O https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz

dialog --backtitle "Arch Linux Easy Install" --title " Yaourt " \
--sleep 1 -- colors --infobox "\n \Z2+ Download des paquets\n \Z4-> Installations des dépendances\n \Z1- Installaton de Yaourt" 8 40
tar zxvf package-query.tar.gz
cd package-query
makepkg -csi
cd ..

dialog --backtitle "Arch Linux Easy Install" --title " Yaourt " \
--sleep 1 -- colors --infobox "\n \Z2+ Download des paquets\n + Installations des dépendances\n \Z4-> Installaton de Yaourt" 8 40
tar zxvf yaourt.tar.gz
cd yaourt
makepkg -csi
cd ..
touch /etc/yaourtrc
mkdir /var/tmp/yaourt
echo 'EDITOR="vim"' >> /etc/yaourtrc
echo 'TMPDIR="/var/tmp/yaourt"' >> /etc/yaourtrc
echo 'EDITFILES=0' >> /etc/yaourtrc

dialog --backtitle "Arch Linux Easy Install" --title " Yaourt " \
--sleep 2 -- colors --infobox "\n\n \Z2+ Download des paquets\n + Installations des dépendances\n + Installaton de Yaourt" 8 40

# Mot de pass root
dialog --backtitle "Arch Linux Easy Install" --title " Mot de passe root " \
--sleep 2 -- colors --infobox "\nLe \Z3mot de passe \Z7pour l'utilisateur \Z3root \Z7vous sera demandé !" 7 40
passwd root

dialog --backtitle "Arch Linux Easy Install" --title " Fin de l'installation " \
--sleep 2 -- colors --infobox "\nMerci d'avoir utilisé EasyInstall ! " 7 40
umount /mnt

echo
clear
echo
echo
read -p "Don't forget to remove the CD"
reboot

# ••¤(`×[¤ Qεяε∂ ¤]×´)¤••

