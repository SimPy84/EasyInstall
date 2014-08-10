#!/bin/bash

# Copyright (c) Vite Aerea

# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# Afin de faciliter, sur mon ordinateur de test, le processus
# d'installation du sytème Arch Linux, ce script est une proposition
# d'automatisation de ce dernier. ArchLinux-easy n'installe que le
# system de base (base et base-devel) ainsi que quelques packages très
# très utiles pour un environement en mode console complet.

@echo ON
clear

echo '+----------------+'
echo '| ArchLinux-esay |'
echo '+----------------+'
echo
echo '   1. Changement de la langue'
echo '   2. Création du système de fichiers'
echo '   3. Montage des partitions'
echo '   4. Sélection du mirroire'
echo '   5. Installation du système de base'
echo '   6. Chroot et Configurations du sytème'
echo '      a. Configuration de la langue et du clavier'
echo '      b. Configuration des composants et processus système'
echo '      c. Installation du bootloader'
echo '      d. Installation des paquets supplémentaires'
echo '      e. Configurations finales'
echo
echo
read -p "Appuyez sur une touche pour continuer, ou \"q\" pour quittez..." a

if [[ ${a} = 'q' ]]; then
  echo
  echo "Fin de l'installation..."
  sleep 1s
  exit 0
elif [[ ${a} = 'Q' ]]; then
  echo
  echo "Fin de l'installation..."
  sleep 1s
  exit 0
fi

clear
echo
echo ' 1. Changement de la langue'
echo '   -------------------------'
echo
echo
sleep 2s
loadkeys be-latin1
sed -i '/fr_FR\.UTF-8/ s/^#//' /etc/locale.gen
locale-gen
export LANG=fr_FR.UTF-8

clear
echo
echo ' 2. Création du système de fichiers'
echo '   ---------------------------------'
echo
echo
sleep 2s
lsblk -io KNAME,TYPE,SIZE,MODEL
echo
read -p "Veuillez choisir le disque à partitionner (ex. /dev/sda) ?" DISK
echo "Table de partition de $DISK :"
parted -s $DISK unit MB print
read -p "Voulez-vous (re)partitioner $DISK. [O/n] " rep
if [[ ${rep} = n ]]; then
  echo
  echo "Fin de l'installation..."
  sleep 2s
  exit 0
fi
echo
echo "Création de la table de partition..."
echo
sgdisk --zap-all $DISK
parted $DISK mklabel msdos
parted $DISK unit MB mkpart primary linux-swap 1 1024
parted -- $DISK unit MB mkpart primary ext4 1024 -0
parted $DISK set 2 boot on
echo ">>> La table de partition de $DISK est la suivante :"
parted -s $DISK unit MB print 
echo
echo "Formatage des disques..."
echo 
mkfs.ext4 /dev/sda2
mkswap /dev/sda1
swapon /dev/sda1

clear
echo
echo ' 3. Montage des partitions'
echo '   ------------------------'
echo
echo
sleep 2s
mount /dev/sda2 /mnt

clear
echo
echo ' 4. Sélection du mirroire'
echo '   -----------------------'
echo
echo
sleep 2s
cp /etc/pacman.d/mirrolist /etc/pacman.d/mirrolist.old
rankmirrors --generate --method rank --country Belgium,Germany,France
#touch /etc/pacman.d/mirrolist
#echo "##" >> /etc/pacman.d/mirrolist
#echo "## Arch Linux repository mirrorlist" >> /etc/pacman.d/mirrolist
#echo "## Sorted by mirror score from mirror status page" >> /etc/pacman.d/mirrolist
#echo "## Generated on 2013-09-15" >> /etc/pacman.d/mirrolist
#echo "##" >> /etc/pacman.d/mirrolist
#echo " " >> /etc/pacman.d/mirrolist
#echo "## Score: 1.5, Belgium" >> /etc/pacman.d/mirrolist
#echo "#Server = http://archlinux.mirror.kangaroot.net/$repo/os/$arch" >> /etc/pacman.d/mirrolist
#echo "## Score: 3.9, Belgium" >> /etc/pacman.d/mirrolist
#echo "#Server = http://archlinux.cu.be/$repo/os/$arch" >> /etc/pacman.d/mirrolist

clear
echo
echo ' 5. Installation du système de base'
echo '   ---------------------------------'
echo
echo
sleep 2s
pacstrap -i /mnt base base-devel
echo
echo \ Generate an fstab
echo -------------------
echo
genfstab -U -p /mnt >> /mnt/etc/fstab

clear
echo
echo ' 6. Chroot et Configurations'
echo '   --------------------------'
echo
echo
sleep 2s
arch-chroot /mnt /bin/bash

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
echo 'LANGUAGE="fr_FR:en_US:en"' >> /etc/locale.conf
echo "" >> /etc/locale.conf
echo "# Keep the default sort order (e.g. files starting with a '.'" >> /etc/locale.conf
echo "# should appear at the start of a directory listing.)" >> /etc/locale.conf
echo 'LC_COLLATE="C"' >> /etc/locale.conf
export LANG=fr_FR.UTF-8
loadkeys be-latin1
touch /etc/vconsole.conf
echo "KEYMAP=be-latin1" >> /etc/vconsole.conf
#echo "FONT=Lat2-Terminus16" >> /etc/vconsole.conf
#echo "FONT_MAP=8859-15" >> /etc/vconsole.conf

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

# ••¤(`×[¤ Qεяε∂ ¤]×´)¤••
