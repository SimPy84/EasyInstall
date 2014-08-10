#!/bin/sh -x

# Copyright (c) Vite Aerea

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
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
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

dialog --backtitle "Arch Linux Easy Install" --title " Language Settings " \
--sleep 2 --infobox "\nKeyboard setting\nLocale" 8 40

clear
loadkeys be-latin1
sed -i '/fr_FR\.UTF-8/ s/^#//' /etc/locale.gen
locale-gen
export LANG=fr_FR.UTF-8


# ••¤(`×[¤ Qεяε∂ ¤]×´)¤••
