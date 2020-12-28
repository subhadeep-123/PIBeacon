#!/bin/bash

# Run this script First

function unblock_bluetooth() {
    echo "Checking If Bluetooth is blocked"
    rfkill list | grep 'yes' >/dev/null
    if [[ '$?' == 0 ]]; then
        rfkill unblock bluetooth
    fi
}

function build_image_dockercompose() {
    if [[ -f docker-compose.yml ]]; then
        docker-compose up -d --build
        echo "--------------------------"
        echo "      Build Complete      "
        echo "--------------------------"
        read -p "Do you run the container[y/n] - " ch
        if [[ $ch == "y" ]]; then
            run_container_docker_compose
        else
            echo -e "\n\nExiting from the script..\n\n"
            exit 1
        fi
    else
        read -p "Enter the Path to the docker-compose.yml - " path
        cd $path
        docker-compose up -d --build
    fi
}

function run_container_docker_compose() {
    echo -e "\n\n\n\n"
    docker images
    echo -e "\n\n"
    ctname="Default_Container"
    echo "Enter the container Name That you wanna Give, else we have a default name - "
    read ctname
    echo "Enter The Image Name - "
    read imgname
    docker run --cap-add=SYS_ADMIN --cap-add=NET_ADMIN --net=host --name $ctname -it $imgname bash
}

sudo killall -9 bluetoothd
unblock_bluetooth
build_image_dockercompose
