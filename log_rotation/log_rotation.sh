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
#                                                                   #
#####################################################################
_EOF_

compression_type=$1

case $1 in
	gzip )
		;;
	bzip2 )
		;;
	xz )
		;;
esac

/var/log/sar/
if [[ -d /var/log/sar ]]; then
 	#statements
 fi 
