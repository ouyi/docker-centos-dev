
# Docker development environment

A dockerized development box based on centos 7. More tools will be added.

## Direct use

    docker run --rm -ti ouyi/docker-centos-dev 

## Use as a base image

Create a Dockerfile similar to this:

    FROM ouyi/docker-centos-dev
    MAINTAINER username

    RUN chmod 4755 /usr/bin/ping

    RUN usernameadd username
    WORKDIR /home/username

Build it with:
    
    docker build . -t username/centos-username

Run it with:

    docker run -u username -v $HOME/home_username:/home/username --name centos-username --rm -ti username/centos-username

You can attach to the container as root:

    docker exec -u 0 -it centos-username bash
    
You may want to change username to whatever name you prefer.
