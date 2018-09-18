#!/bin/bash

pidof usbipd || usbipd -D
usbip bind -b 1-1

