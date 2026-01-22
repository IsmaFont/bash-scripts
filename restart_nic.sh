#!/bin/bash


NET_INTERFACE=""
CONT_CHECK=""
INTERFACE_GATEWAY=""


printStartingMessage() {
	echo "Welcome, this script will restart a missbehaving network interface, be careful and glance over the script before doing any critical tasks!"
}

gatherNetworkInterfaceVars() {
	printf "Input the desired network interface to be restarted: "
	read NET_INTERFACE
	printf "Input the network's gateway ip: "
	read INTERFACE_GATEWAY
}

showNetworkInterfaceInfo() {
	ip address
}

bringDownNetworkInterface() {
	ip link set $NET_INTERFACE down
}

reconfigureNetworkInterface() {
	ip link set $NET_INTERFACE up
}

checkNetworkInterfaceConnectivity() {
	ip link show $NET_INTERFACE
	ping -c1 $INTERFACE_GATEWAY
}

main() {
	
	# Check interface info before contiuning
	printf "Interfaces OK? [y,n]: "
	if [[ $CONT_CHECK != "y" | $CONT_CHECK != "Y" ]]; then
		exit 0;
	fi

	printStartingMessage
	gatherNetworkInterfaceVars

	# brings network interface down
	bringDownNetworkInterface
	
	# brings network interface up
	reconfigureNetworkInterface
	
	# Checks l2 and l3 communication
	checkNetworkInterfaceConnectivity
	
	exit 0
}