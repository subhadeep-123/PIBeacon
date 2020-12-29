#!/bin/bash

# Run this Script when in the container
service dbus start
bluetoothd &

/bin/bash
