#!/bin/bash

cat <<_EOF_
#####################################################################
#                                                                   #
#                             DISCLAIMER                            #
#    This script is provided as-is without warranty of any kind.    #
#    The author accepts no responsibility for its use or misuse.    #
#  Users are encouraged to review and modify the script as needed.  #
#  By using this script, you agree to accept all associated risks.  #
#                                              - Ismael F.G.        #
# Rev. 0.0                                                          #
#####################################################################

_EOF_

# =============================================================================
# SCRIPT: wgsetup.sh
# DESCRIPTION: Install WireGuard and import virtual network interface card profile
# USAGE: ./wgsetup.sh
# AUTHOR: Ismael F.G.
# DATE: 2024-11-20
# VERSION: 1.0 rev 0 xD
# =============================================================================

# =====================
# Global Variables
# =====================

readonly FILENAME="wrgrd0" # ".conf" is appended per command

# =====================
# Functions
# =====================

show_help() {
  cat <<_EOF_
Usage: $0 [-h]
  -h
        Display this help message.

_EOF_
}

# =====================
# Main Execution Block
# =====================

main() {
	echo "Script name: $(basename $0)"
		if [ $(id -u) -ne 0 ]; then
			echo "Run this with sudo!"
		else
			# update apt cache and install wireguard
			apt update
			apt install -y wireguard
			
			# copy vnic config file to wireguard directory and set it's permission to "rw- --- ---"
			cp ./$FILENAME.conf /etc/wireguard/$FILENAME.conf
			chmod 600 /etc/wireguard/$FILENAME.conf
			
			# enable vnic
			wg-quick up $FILENAME
			
			# enable wireguard service, configured to enable vnic at boot
			#systemctl enable wg-quick@$FILENAME
			
			# check status
			wg
			
		fi
}

main "$@"

#  if [[ DRY_RUN ]]; then
#    printf " \n"
#    
#    return 1
#  fi
#


