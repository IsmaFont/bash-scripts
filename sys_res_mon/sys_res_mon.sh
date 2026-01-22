!#/bin/bash

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
# SCRIPT: sys_res_mon.sh
# DESCRIPTION: 
# USAGE: ./sys_res_mon.sh
# AUTHOR: Ismael F.G.
# DATE: 2024-05-26
# VERSION: 1.0
# =============================================================================

# =====================
# Global Variables
# =====================


# =====================
# Functions
# =====================

check_cpu_usage () {
  sar -u 1 5
} # Check cpu load

check_mem_usage () {
  free 
} # Check ram n swap usage

check_disk_io () {
  iostat
} # Check local and NFS iops

check_net_io () {} # Check network communications

check_net_health () {} # Check HBA and NIC health
check_disk_health () {} # Check S.M.A.R.T. and RAID health


# =====================
# Main Execution Block
# =====================

main() {
    echo "Script name: $(basename $0)"
    for arg in "$@"; do
      case $arg in
        -d|--dry*)
          input_value="${arg#*=}"
          shift
          ;;
        --output=*)
          output_value="${arg#*=}"
          shift
          ;;
        *)
          # Handle other arguments or show usage
          ;;
      esac
    done
}

main