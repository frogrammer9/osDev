#!/bin/bash

if make all ; then
qemu-system-i386 -hda build/os.img
fi
