#!/bin/bash

bear -- make all;
qemu-system-i386 -hda build/os.img
