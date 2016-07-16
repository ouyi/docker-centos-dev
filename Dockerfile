FROM centos:latest
MAINTAINER Yi Ou

# Update the image with the latest packages (recommended)
RUN yum update -y && yum clean all

RUN yum install -y epel-release man which tree bash-completion vim-enhanced git rpm-build tmux pdsh bc && yum clean all

RUN yum -y install python-pip python-paramiko && yum clean all

RUN pip install radon pylint pep8 ansible awscli datadog

RUN curl --silent --location https://rpm.nodesource.com/setup_4.x | bash -

RUN yum -y install nodejs && yum clean all

COPY gitconfig  /root/.gitconfig
COPY vimrc /root/.vimrc
COPY tmux.conf /root/.tmux.conf

COPY bashrc /tmp/bashrc
RUN cat /tmp/bashrc >> /root/.bashrc  && rm -f /tmp/bashrc

WORKDIR /root
