#!/bin/bash

echo "=== Loading USB Module ==="
esxcli system module load -m vmkusb
echo "✅ vmkusb loaded"

echo "=== Enable usbarbitrator on boot ==="
chkconfig usbarbitrator on
echo "✅ usbarbitrator enabled on boot"

echo "=== Starting usbarbitrator ==="
/etc/init.d/usbarbitrator start force
echo "✅ usbarbitrator started"

echo "=== Enable USB Passthrough for Dongles ==="
esxcli hardware usb passthrough device enable -d 2:2:12d1:1446
esxcli hardware usb passthrough device enable -d 2:3:12d1:1446
echo "✅ Passthrough enabled"

echo "=== Verify ==="
esxcli hardware usb passthrough device list
