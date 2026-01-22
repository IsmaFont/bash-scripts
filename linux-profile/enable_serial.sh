#!/bin/bash

# Script to enable serial console on RHEL 9> based KVM guest.
# !! Not tested in metal

SERIAL_PORT=0

echo "Remember to add serial port to guest via Proxmox!"
grubby --update-kernel=ALL --args="console=ttyS0,115200 console=tty0"
systemctl enable serial-getty@ttyS0.service


GRUB_CMDLINE_LINUX_DEFAULT="console=ttyS0,115200"

res() {

  old=$(stty -g)
  stty raw -echo min 0 time 5

  printf '\0337\033[r\033[999;999H\033[6n\0338' > /dev/tty
  IFS='[;R' read -r _ rows cols _ < /dev/tty

  stty "$old"

  # echo "cols:$cols"
  # echo "rows:$rows"
  stty cols "$cols" rows "$rows"
}

[ $(tty) = /dev/ttyS0 ] && res

stty rows 50 cols 132
