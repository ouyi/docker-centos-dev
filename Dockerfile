FROM centos:latest
MAINTAINER Yi Ou

# Make man pages work
RUN sed -i 's/tsflags=nodocs//g' /etc/yum.conf

# Update the image with the latest packages (recommended)
RUN yum update -y && yum clean all

# Command-line tools and config files
RUN yum install -y epel-release man which tree bash-completion vim-enhanced git rpm-build tmux pdsh bc wget telnet net-tools lsof socat pdsh && yum clean all

COPY config/gitconfig  /root/.gitconfig
COPY config/vimrc /root/.vimrc
COPY config/tmux.conf /root/.tmux.conf
COPY config/bashrc /tmp/bashrc
RUN cat /tmp/bashrc >> /root/.bashrc  && rm -f /tmp/bashrc

# Install python stuff
RUN yum -y install python-pip python-paramiko && yum clean all
RUN pip install --upgrade pip && pip install radon pylint pep8 ansible awscli datadog

# Install javascript stuff
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN yum -y install nodejs ruby && yum clean all
RUN gem install sass && npm install -g grunt-cli && npm install -g bower

# Install java and maven
RUN yum -y install java-1.8.0-openjdk-devel.x86_64 maven && yum clean all
COPY config/java_env.sh /etc/profile.d/java_env.sh
COPY config/maven_env.sh /etc/profile.d/maven_env.sh

# Install antlr4
ENV ANTLR_JAR antlr-4.5.3-complete.jar
RUN curl http://www.antlr.org/download/${ANTLR_JAR} -o /usr/local/lib/${ANTLR_JAR}
COPY config/antlr4.sh /etc/profile.d/antlr4.sh

# Install packer
RUN wget https://releases.hashicorp.com/packer/0.12.0/packer_0.12.0_linux_amd64.zip -O /tmp/packer.zip
RUN unzip /tmp/packer.zip -d /usr/local/packer && ln -s /usr/local/packer/packer /usr/local/bin/packer.io && rm -f /tmp/packer.zip

# Required by GUI applications
RUN yum install -y libXext libXrender libXtst && yum clean all

WORKDIR /root

# Allow non-root user in the container
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
