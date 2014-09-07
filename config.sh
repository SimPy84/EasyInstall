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
Bienvenu dans le script d'installation d'Arch Linux façon Vite Aerea.
Ce Script propose une installation automatisée d'Arch Linux." 12 60
if [ "$?" = "1" ]
then
  dialog --backtitle "Arch Linux Easy Install" --title " Au revoir " \
  --sleep 2 --infobox "\n\nFin de l'installation..." 8 40
  clear
  exit 0
fi




clear
echo
echo ' 6.a Configuration de la langue et du clavier'
echo
echo
sleep 2s
sed -i '/en_US\.UTF-8/ s/^#//' /etc/locale.gen
sed -i '/fr_FR\.UTF-8/ s/^#//' /etc/locale.gen
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
loadkeys be-latin1
touch /etc/vconsole.conf
echo "KEYMAP=be-latin1" >> /etc/vconsole.conf
echo "FONT=lat9w-16" >> /etc/vconsole.conf
echo "FONT_UNIMAP=lat9w" >> /etc/vconsole.conf

clear
echo
echo ' 6.b Configuration des composants et processus système'
echo
echo
sleep 2s
ln -s /usr/share/zoneinfo/Europe/Brussels /etc/localtime
hwclock --systohc --utc
#hostnamectl set-hostname ViteAerea.test
#pacman -S ipw2200-fw
systemctl enable dhcpcd.service
#sed -i 's/block filesystems/block lvm2 filesystems/g' /etc/mkinitcpio.conf
mkinitcpio -p linux

clear
echo
echo ' 6.c Installation du bootloader'
echo
echo
sleep 2s
pacman -S grub
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

clear
echo
echo ' 6.d Installation des paquets supplémentaires'
echo
echo
sleep 2s
pacman -S vim-runtime mc gpm wget zsh git

echo
echo Yaourt
echo
curl -O https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
tar zxvf package-query.tar.gz
cd package-query
makepkg -csi
cd ..
curl -O https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
tar zxvf yaourt.tar.gz
cd yaourt
makepkg -csi
cd ..

clear
echo
echo ' 6.e Configurations finales'
echo
echo
sleep 2s
touch /etc/yaourtrc
mkdir /var/tmp/yaourt
echo 'EDITOR="vim"' >> /etc/yaourtrc
echo 'TMPDIR="/var/tmp/yaourt"' >> /etc/yaourtrc
echo 'EDITFILES=0' >> /etc/yaourtrc

echo
echo
echo 'Entrez le mot de passe root'
echo
passwd


clear
echo
echo " Fin de l'installation !"
echo
exit
umount /mnt

echo
clear
echo
echo
read -p "Don't forget to remove the CD"
reboot
