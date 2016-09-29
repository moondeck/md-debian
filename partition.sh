#!/bin/bash

sudo fdisk distimage.img <<EOF
o
n
p
1


w
q
EOF
