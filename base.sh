#!/bin/bash

set v

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

clear
echo '+----------------+'
echo '| ArchLinux-esay |'
echo '+----------------+'
echo
echo ' 1. Changement de la langue'
echo ' 2. Création du système de fichiers'
echo ' 3. Montage des partitions'
echo ' 4. Sélection du mirroire'
echo ' 5. Installation du système de base'
echo ' 6. Chroot et Configurations du sytème'
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
echo ' -------------------------'
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
echo ' ---------------------------------'
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
echo ' ------------------------'
echo
echo
sleep 2s
mount /dev/sda2 /mnt
clear
echo
echo ' 4. Sélection du mirroire'
echo ' -----------------------'
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
echo ' ---------------------------------'
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
echo ' --------------------------'
echo
echo
sleep 2s
arch-chroot /mnt /bin/bash



# ••¤(`×[¤ Qεяε∂ ¤]×´)¤••
