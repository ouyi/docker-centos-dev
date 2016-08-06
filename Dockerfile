FROM centos:latest
MAINTAINER Yi Ou

# Update the image with the latest packages (recommended)
RUN yum update -y && yum clean all

RUN yum install -y epel-release man which tree bash-completion vim-enhanced git rpm-build tmux pdsh bc wget && yum clean all

RUN yum -y install python-pip python-paramiko && yum clean all

RUN pip install radon pylint pep8 ansible awscli datadog

RUN curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -

RUN yum -y install nodejs && yum clean all

ENV JAVA_VERSION 8u102
ENV BUILD_VERSION b14

# Downloading Java
RUN wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm

RUN yum -y install /tmp/jdk-8-linux-x64.rpm
RUN rm /tmp/jdk-8-linux-x64.rpm

RUN alternatives --install /usr/bin/java jar /usr/java/latest/bin/java 200000
RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000
RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000

ENV JAVA_HOME /usr/java/latest
RUN yum -y install maven && yum clean all

COPY gitconfig  /root/.gitconfig
COPY vimrc /root/.vimrc
COPY tmux.conf /root/.tmux.conf

COPY bashrc /tmp/bashrc
RUN cat /tmp/bashrc >> /root/.bashrc  && rm -f /tmp/bashrc

WORKDIR /root
