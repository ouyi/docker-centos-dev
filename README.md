
# Docker development environment

A dockerized development box based on centos 7. More tools will be added.

## Direct use

    docker run --rm -ti ouyi/docker-centos-dev 

## Use as a base image

Create a Dockerfile similar to this:

    FROM docker-centos-dev
    MAINTAINER you

    RUN chmod 4755 /usr/bin/ping

    RUN useradd you
    WORKDIR /home/you

Build it with:
    
    docker build . -t centos-you

Run it with:

    docker run -u you -v $HOME/code:/home/you/code --name centos-you --rm -ti centos-you

You can attach to the container as root:

    docker exec -u 0 -it centos-you bash
    
