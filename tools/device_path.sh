#!/bin/bash

devstr=$1

char="/"
let pos=`echo "$devstr" | awk -F "$char" '{printf "%d", length($0)-length($NF)}'`

usb_dev=${devstr:$pos:${#devstr}}

echo $usb_dev > /tmp/uefi.fifo
