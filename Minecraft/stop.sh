#!/bin/bash

# Server folder
SRVPATH='/home/minecraft/guarida2'

# Screen name
SCRNAME='guarida2'


cd "$SRVPATH"

echo saving world
screen -S "$SCRNAME" -X stuff "save-all\n"
sleep 5
echo saved

echo stopping server
screen -S "$SCRNAME" -X stuff "stop\n"
sleep 3
echo stopped
