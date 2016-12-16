
# Docker development environment

A dockerized development box based on centos 7. More tools will be added.

## Direct use

    docker run --rm -ti ouyi/docker-centos-dev 

or

    docker run --net=host -w "/home/$USER" -e LOCAL_USER_NAME=$USER -e LOCAL_USER_ID=$(id -u $USER) -v $HOME/home_$USER:/home/$USER --name some_name -ti ouyi/docker-centos-dev

On Fedora 25, I had to either use the `--privileged` option or `sudo setenforce 0` to get around permission issues.

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
