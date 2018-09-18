#!/bin/bash

if [ "$(whoami)" != "root" ]; then
	echo "Enter your account password (nothing will display as you type)"
	sudo $0 $@
	exit
fi

trap "quit" exit INT TERM 0

quit() {
	usbip detach -p 00 > /dev/null 2>&1 && echo "Scanner detached"
	sleep 1
	knock 192.168.1.125 -d 100 $closePorts
	exit
}

#PortPlaceholder1
#PortPlaceholder2
#ipPlaceholder

if [ "$openPorts" ==  "" ]; then
        read -p "IP address of PiZeroW: " ip
        sed -i "s/^#ipPlaceholder/ip='$ip'/" "$0"
	read -p "List of space-separated ports to attach device [3108 2709 5821]: " openPorts
	[ "$openPorts" == "" ] && openPorts='3108 2709 5821'
	sed -i "s/^#PortPlaceholder1/openPorts='$openPorts'/" "$0"
	read -p "List of space-separated ports to attach device [1455 2745 3393]: " closePorts
	[ "$closePorts" == "" ] && closePorts='1455 2745 3393'
	sed -i "s/^#PortPlaceholder2/closePorts='$closePorts'/" "$0"
fi

knock $ip -d 100 $openPorts
sleep 1

modprobe usbip-core
modprobe vhci-hcd

usbip attach -r $ip -b 1-1 && echo "Scanner attached"

# wait for user input before detaching
read -p "Press [Enter] to detach scanner"

quit

