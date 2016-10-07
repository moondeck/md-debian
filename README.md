# md-debian
Debian build system for Orange Pi and other Allwinner H3 boards (will support more in the future if I get my hands on them. donations/testers/contributors welcome.)

## BASIC USAGE
You need sudo installed and set up.
Adjust Makefile defines to your system
Then, if you dont have the dependencies required, run (as root) "build.sh" , it will download them for you
If you do have the dependencies and compilers, then you can just run "make" as root (or with sudo, its fine.)
The script will ask you for the root password and run tasksel if you want to install anything.

## FUTURE:
I am planning to set up a repo for shipping kernel updates and custom applications (not anything major, just chip-specific stuff, like for changing resolution, etc.)

The build script is tested on Debian Stretch, and its the only supported platform for now, but it should work on anything with minor modifications (replace "CROSS_COMPILE" and "CC" with any triplet your system uses.)

## LICENSE:
Its provided AS-IS, without warranty of any kind.
I am not responsible for burned boards, accidentally formated drives, broken SD cards or nuclear war.
None of these things should happen if used properly.

I, and this project is not affiliated,sponsored or endorsed by Debian
