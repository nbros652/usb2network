#!/bin/bash

systemctl stop cups

# vendor:product ids of desired printer to attach 
# (uncomment and update the next line if you're using a USB hub or rpi with multiple USB ports)
#ids=0000:0000
if [ -z "$ids" ]; then
  dev=1-1
else
  dev="$(usbip list -l | grep $ids | grep -oP "\d-\d\.\d")"
fi

usbip unbind -b $dev

systemctl start cups
