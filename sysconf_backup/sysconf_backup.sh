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
# SCRIPT: sysconf_backup.sh
# DESCRIPTION: This script copies over configuration files and compresses them 
#              under /root/sysconf_backup/, then mails the compressed file to
#              the mail assigned under the variable named email_addr.
# USAGE: ./sysconf_backup.sh [-d|--dry]
# AUTHOR: Ismael F.G.
# DATE: 2024-05-26
# VERSION: 1.0
# =============================================================================

# =====================
# Global Variables
# =====================

readonly CURRENT_DATE=$(date +%Y-%m-%d)
readonly NODENAME=$(hostname)
API_GATEWAY="https://api.com/v2/api"

# E-mail to send backup to
email_addr=user@example.com

DRY_RUN=false
main_dir="/root/sysconf_backup"
zip_dir="$main_dir"
# Array of directories to backup
declare -a config_dir
config_dir[1]="/etc/nginx"
config_dir[2]="/etc/network"


# =====================
# Functions
# =====================

# Show help
show_help() {
  cat <<_EOF_
Usage: $0 [options] {arguments}
Available options:
  -d | --dry-run
        Dry-run mode. Prints commands to screen without actually running them.
  -h | --help
        Display this help message.
  -o | --output {path}
        Specify main directory for backup.
  -z | --zip-dir {path}
        Specify compressed backup file directory.
  -g | --api-gateway {link}
        Specify API gateway link to retrieve config paths to be backed-up
_EOF_
}

# If API online, clear config_dir array and push API responses to config_dir.
function set_remote_path() {
  if curl --output /dev/null --silent --head --fail "$API_GATEWAY"; then
    config_dir=()
    local api_response=$(curl -s $API_GATEWAY | jq ".path")
    while IFS= read -r path; do
      config_dir[i]="$path"
     ((i++))
    done <<< $api_response
  else
    echo "API Gateway unreachable."
    exit 1
  fi
}

# Create backup directory
function setup_dir() {
  if [[ $DRY_RUN = true ]]; then
    if ! [[ -d "$main_dir" ]]; then
      printf "mkdir $main_dir\n"
    fi
    return 0
  fi

  printf "Creating main directory...\n"
  if ! [[ -d "$main_dir" ]]; then
    mkdir $main_dir
    printf "Created main directory under $main_dir\n"
  else
    printf "Directory $main_dir already exists!\n"
  fi
  printf "Done!\n\n"
}


# Copy config files into backup directory
function copy_conf() {
  if [[ $DRY_RUN = true ]]; then
    for dir in "${config_dir[@]}"; do
      printf "cp -bfdRT --suffix=_${CURRENT_DATE}.bak --preserve=all $dir $main_dir/$(basename $dir)\n"
    done
    return 0
  fi

  for dir in "${config_dir[@]}"; do
    printf "Copying over $dir to $main_dir/$(basename $dir)...\n"
    if [[ -d $main_dir/$(basename $dir) ]]; then
      printf "Directory $main_dir/$(basename $dir) already exists! Overwriting...\n"
    fi
      cp -bfdRT --suffix=_${CURRENT_DATE}.bak --preserve=all $dir $main_dir/$(basename $dir)
      printf "Done!\n\n"
  done
}


# Tar and compress backup directory
function archive_backup() {
  if [[ $DRY_RUN = true ]]; then
    printf "tar -czf $zip_dir/backup_$CURRENT_DATE.tar.gz $main_dir\n"
    return 0
  fi

  tar -czf $zip_dir/backup_$CURRENT_DATE.tar.gz $main_dir
}


# E-mail archived backup to email_addr var
function mail_backup() {
  if [[ $DRY_RUN = true ]]; then
    printf "mail -a $main_dir/backup_$CURRENT_DATE -s 'Backup sysconfig $CURRENT_DATE' $email_addr < /dev/null\n"
    return 0
  fi
  mail -a $main_dir/backup_$CURRENT_DATE -s "Backup sysconfig $CURRENT_DATE" $email_addr < /dev/null
}


# Print file structure (original config path + new path inside backup dir) to file_structure.txt
function print_file_structure() {
  if [[ $DRY_RUN = true ]]; then
    for dir in "${config_dir[@]}"; do
      printf "echo '$dir >> $(basename $dir)' >> $main_dir/file_structure.txt\n"
    done
    return 0
  fi

  for dir in "${config_dir[@]}"; do
    echo "$dir >> $(basename $dir)" >> $main_dir/file_structure.txt
  done
}


# Gather parameters
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


function oopsie() {
  echo "you did an oopsie!"
  oopsie | oopsie&
}

# =====================
# Main Execution Block
# =====================

main() {
  printf "Script name: $(basename $0)\n\n"
  gather_params "$@"
  setup_dir
  copy_conf
  archive_backup
  mail_backup
  print_file_structure
}

main "$@"



