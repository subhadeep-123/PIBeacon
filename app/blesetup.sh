#!/bin/bash

clear
systemctl start bluetooth
systemctl status bluetooth | grep Failed >/dev/null
if [[ "$?" == 0 ]]; then
    echo "Need to Unlock Bluetooth"
    echo "checking if hcio is blocked"
    rfkill list | grep 'yes' >/dev/null
    if [[ '$?' == 0 ]]; then
        rfkill unblock bluetooth
    fi
else
    echo "No Blocked Signals!!"
fi

echo "Setting Up PI"

hciconfig hci0 up
hciconfig hcio leadv 3
# sudo hcitool -i hci0 cmd 0x08 0x0008 33 61 35 33 38 64 37 32 2d 65 38 38 31 2d 35 62 63 32 2d 62 31 39 32 2d 35 65 36 36 35 38 39 37 31 32 37 38 00 00 00 00 C8
#
hcitool -i hci0 cmd 0x08 0x0008 1E 02 01 1A 1A FF 4C 00 02 15 63 6F 3F 8F 64 91 4B EE 95 F7 D8 CC 64 A8 63 B5 00 00 00 00 C8
