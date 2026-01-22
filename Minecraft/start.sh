#!/bin/bash
# Set constants #

# Name of the screen 
server_name='placeholder'

# Server directory
server_path='/home/minecraft/placeholder'

# JVM package version 
jvm_version='java-11-openjdk-amd64'

# Memory allocation (in GB)
mem_alloc='4'

argument="$1"
input="$2"


function startServer {
        echo "Starting server under $server_name"
        screen -dmS "$server_name" /usr/lib/jvm/"$jvm_version"/bin/java -Xms"$mem_alloc"G -Xmx"$mem_alloc"G -jar "$server_path"/paper.jar nogui
        echo 'Server started'
}


function stopServer {
        echo "Saving world"
        screen -S "$server_name" -X stuff "save-all\n"
        sleep 5
        echo "World saved!"

        echo "Stopping server"
        screen -S "$server_name" -X stuff "stop\n"
        sleep 3
        echo "Server stopped!"
}


function restartServer {
        stopServer &&
        startServer

}

function echoToServer {
        screen -S "$server_name" -X stuff "$*\n" 
}

# Main proc
cd $server_path
case $argument in
        start)
        startServer
        ;;
        "stop")
        stopServer
        ;;
        restart)
        restartServer
        ;;
        echo)
        echoToServer say $input
        ;;
        *)
        echo "bruh"
        ;;
esac

#rev0