#!/bin/sh

if [ -r /usr/local/spot-on/Spot-On ] && [ -x /usr/local/spot-on/Spot-On ]
then
    export LD_LIBRARY_PATH=/usr/local/spot-on/Lib
    cd /usr/local/spot-on && exec ./Spot-On "$@"
    exit $?
else
    exit 1
fi
