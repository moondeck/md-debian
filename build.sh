#!/bin/bash

sudo dpkg --add-architecture armhf
sudo apt-get install -yy build-essential git gcc-5-arm-linux-gnueabihf sunxi-tools
echo "installed dependencies"
sudo make $1
echo "moondeck's debian build system done. thanks for using me."
