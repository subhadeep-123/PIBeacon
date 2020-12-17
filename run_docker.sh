#!/bin/bash

clear

function build_image_dockercompose() {
    if [[ -f docker-compose.yml ]]; then
        docker-compose up -d --build
        echo "--------------------------"
        echo "      Build Complete      "
        echo "--------------------------"
        echo "Enter the container Name - " 
        read ctname
        docker exec -it $ctname bash
    else
        read -p "Enter the Path to the docker-compose.yml - " path
        cd $path
        docker-compose up -d --build
    fi
}

function build_image_dockerfile() {
    read -p "Enter the Tagname - " tag
    if [[ -f Dockerfile ]]; then
        docker build -t $tag .
    else
        read -p "Enter the Path to the Dockerfile - " path
        cd $path
        docker build -t $tag .
    fi
}

function run_container_dockerfile() {
    echo "Do You wanna Build the Image First [y/n] - "
    read ch
    if [[ $ch == 'y' ]]; then
        echo "Enter the Image name with tag [img:tag] - "
        read img
        docker images | grep $img >>/dev/null
        if [[ $? == 0 ]]; then
            read -p "Image is already Present Do you still wanna built [y/n]" chh
            if [[ $chh == 'y' ]]; then
                build_image_dockerfile
            fi
        else
            echo "Building the Image.."
            sleep 2
            build_image_dockerfile
        fi
    else
        echo "Enter the Image name with tag [img:tag] - "
        read img
        read -p "Enter the name that you give to the container" name
        docker run --name $name -d $img
    fi
}

function delete_images() {
    echo "Do You wanna Delete all Images [y/n] - "
    read ch
    if [[ $ch == 'y' ]]; then
        echo "Deleting All Images"
        sleep 2
        docker images -a && docker system prune -a
        echo "All Images Deleted"
        sleep 2
    else
        echo "Enter the Image name with tag [img:tag] - "
        read img
        docker rmi -f $img
    fi

    read -p "Do you wanna Delete the Container/Containers [y/n]" ch
    if [[ $ch == 'y' ]]; then
        delete_containers
    fi
}

function delete_containers() {
    echo "Do You wanna Delete all Containers [y/n] - "
    read ch
    if [[ $ch == 'y' ]]; then
        echo "Deleting All Containers"
        sleep 2
        docker container ls --all && docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
        echo "All containers Deleted"
        sleep 2
    else
        echo "Enter the Container Name - "
        read cname
        docker rm -f $cname
    fi

    read -p "Do you wanna Delete the Image/Images [y/n]" ch
    if [[ $ch == 'y' ]]; then
        delete_images
    fi
}

function help() {
    cat <<HELP

        usage: docker-script [--help] [--build] [--run] [--delcon] [--delimg]

        The Purpose of this commands are:-

        --build
                It Build the Image from Dockerfile, Takes a few input in the process :-
                    
                    1> tagName - For Giving a Name and a tag to the Image [imgName:tag].
                    2> Path - If the Docker File is not present in the current Direcotry.
        
        --run
                It Runs a container from the Image build from Dockerfile, Takes a few input in the process :-
                    
                    1> Choice - [y/n] If we wanna build the Image First.
                    2> imageName - Asks for  the Image Name, cause ain't it ovious.
                    3> containerName - Ask for the name we wanna give to the container.

        --build_compose
                It Build the Image from docker-compose.yml file, and gets inside the shell. Takes a few input in the process :-
                    
                    1> containerName - To execute the shell in Interactive mode we need the containers name.
                    2> Path - If the Docker File is not present in the current Direcotry.

        --delcon
                It Deletes the Container/Containers, Takes a few input in the process :-
                    
                    1> Choice - [y/n] If we delete all Containers.
                    2> containerName - For which Container we wanna delete particularly.
                    3> Choice - [y/n] If we wanna delete the Images too.

        --delimg
                It Deletes the Image/Imagess, Takes a few input in the process :-
                    
                    1> Choice - [y/n] If we delete all Images.
                    2> imageName - For which Image we wanna delete particularly.
                    3> Choice - [y/n] If we wanna delete the Container too.

        --help
                It shows this Documents
HELP
}

if [ "$1" == "--help" ]; then
    help
fi

if [ "$1" == "--build" ]; then
    build_image_dockerfile
fi

if [ "$1" == "--run" ]; then
    run_container_dockerfile
fi

if [ "$1" == "--build-compose" ]; then
    build_image_dockercompose
fi

if [ "$1" == "--delcon" ]; then
    delete_containers
fi

if [ "$1" == "--delimg" ]; then
    delete_images
fi

#If Not Arguments
NO_ARGS=0
if [ "$#" -eq $NO_ARGS ]; then
    echo "Error: Invalid no of Arguments. Try '--help' for more info!!" >&2
    help
fi


