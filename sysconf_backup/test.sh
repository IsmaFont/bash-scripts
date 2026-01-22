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
# SCRIPT: example_script.sh
# DESCRIPTION: This script demonstrates the basic structure of a well-organized
#              Bash script, including comments, variables, functions, and the
#              main execution block.
# USAGE: ./example_script.sh
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
API_GATEWAY=putolocro
# =====================
# Main Execution Block
# =====================

function gather_params() {
  options=$(getopt -o "dho:z:g::" --long "dry-run,help,output:,zip-dir:,api-gateway::" -- "$@")
  eval set -- "$options"
  for opt; do
    case "$1" in
      -d|--dry-run)
        DRY_RUN=true
        printf "### DRY-RUN MODE ###\n"
        shift
        ;;
      -h|--help)
        show_help
        exit 0
        ;;
      -o|--output)
        main_dir="$2"
        shift 2
        ;;
      -z|--zip-dir)
        zip_dir="$2"
        shift 2
        ;;
      -g|--api-gateway)
        if [ $4 ]; then
          API_GATEWAY=$4;
          printf "API Gateway set to $API_GATEWAY\n"
        else
          printf "No API Gateway specified. Defaulting to $API_GATEWAY\n"
        fi
        set_remote_path
        shift 2
        ;;
      --)
        shift
        break
        ;;
      *)
        echo "Invalid option: $1" >&2
        show_help
        exit 1
        ;;
    esac
  done
}

gather_params "$@"


#  if [[ DRY_RUN ]]; then
#    printf " \n"
#    
#    return 1
#  fi