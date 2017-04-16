#!/bin/bash

#wow this is such a hack

sudo fdisk $1-$2-$3-image.img <<EOF
o
n
p
1


w
q
EOF 

echo "Done partitioning"
