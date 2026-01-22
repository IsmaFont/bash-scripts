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
#                                                                   #
#####################################################################

_EOF_


# =============================================================================
# SCRIPT: skeleton.sh
# DESCRIPTION: This script demonstrates the basic structure of a well-organized
#              Bash script, including comments, variables, functions, and the
#              main execution block.
# USAGE: ./skeleton.sh
# AUTHOR: Ismael F.G.
# DATE: YYYY-MM-DD
# VERSION: 1.0
# =============================================================================

# =====================
# Global Variables
# =====================


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
	while getopts ":h" opt; do
	  case $opt in
	    h)
	      show_help
	      ;;
	    :)
	      echo "Option -$OPTARG requires an argument." >&2
	      show_help | tail -n+2 | sed -n "/-$OPTARG/,/ -[a-zA-Z]/p" | sed '$d'
	      ;;
	    ?)
	      echo "Invalid option: -$OPTARG" >&2
	      show_help
	      ;;
	  esac
	done
}

main "$@"

#  if [[ DRY_RUN ]]; then
#    printf " \n"
#    
#    return 1
#  fi