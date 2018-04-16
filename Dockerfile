FROM centos:latest
MAINTAINER Yi Ou

# Make man pages work
RUN sed -i 's/tsflags=nodocs//g' /etc/yum.conf

# Update the image with the latest packages
RUN yum update -y && yum clean all

# Command-line tools and config files
RUN yum install -y epel-release && yum clean all
RUN yum install -y man which tree bash-completion vim-enhanced git rpm-build tmux bc wget telnet net-tools lsof socat iotop pdsh ascii && yum clean all

COPY config/gitconfig  /root/.gitconfig
COPY config/vimrc /root/.vimrc
COPY config/tmux.conf /root/.tmux.conf
COPY config/bashrc /tmp/bashrc
RUN cat /tmp/bashrc >> /root/.bashrc  && rm -f /tmp/bashrc

# Install Python stuff
RUN yum -y install python-pip && yum clean all
RUN pip install --upgrade pip && pip install radon pylint pep8 ansible awscli datadog

# Install JavaScript stuff
RUN curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
RUN yum -y install nodejs && yum clean all
RUN npm install -g grunt-cli && npm install -g bower && npm install -g http-server

# Install Java, Maven, and Ant
RUN yum -y install java-1.8.0-openjdk-devel.x86_64 maven ant && yum clean all
COPY config/java_env.sh /etc/profile.d/java_env.sh
COPY config/maven_env.sh /etc/profile.d/maven_env.sh
COPY config/ant_env.sh /etc/profile.d/ant_env.sh

# Install antlr4
ENV ANTLR_JAR antlr-4.5.3-complete.jar
RUN curl http://www.antlr.org/download/${ANTLR_JAR} -o /usr/local/lib/${ANTLR_JAR}
COPY config/antlr4.sh /etc/profile.d/antlr4.sh

# Install Apache Pig local mode
RUN wget http://apache.mirrors.pair.com/pig/pig-0.17.0/pig-0.17.0.tar.gz -O /tmp/pig.tar.gz
RUN tar xzf /tmp/pig.tar.gz -C /usr/local/
COPY config/pig_env.sh /etc/profile.d/pig_env.sh

# Install packer
RUN wget https://releases.hashicorp.com/packer/1.2.2/packer_1.2.2_linux_amd64.zip -O /tmp/packer.zip
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

# Install groovy
RUN groovy_version=2.4.15 \
    && wget "https://bintray.com/artifact/download/groovy/maven/apache-groovy-binary-${groovy_version}.zip" -O /tmp/groovy.zip \
    && unzip /tmp/groovy.zip -d /opt/groovy \
    && rm -f /tmp/groovy.zip \
    && ln -sfnv "groovy-${groovy_version}" /opt/groovy/latest
COPY config/groovy_env.sh /etc/profile.d/groovy_env.sh

# Install gradle
RUN gradle_version=4.5.1 \
    && wget "http://downloads.gradle.org/distributions/gradle-${gradle_version}-bin.zip" -O /tmp/gradle.zip \
    && unzip /tmp/gradle.zip -d /opt/gradle \
    && rm -f /tmp/gradle.zip \
    && ln -sfnv "gradle-${gradle_version}" /opt/gradle/latest
COPY config/gradle_env.sh /etc/profile.d/gradle_env.sh

# Install spring-boot-cli
RUN spring_boot_cli_version=1.5.8.RELEASE \
    && wget "https://repo.spring.io/release/org/springframework/boot/spring-boot-cli/${spring_boot_cli_version}/spring-boot-cli-${spring_boot_cli_version}-bin.zip" -O /tmp/spring-boot-cli.zip \
    && unzip /tmp/spring-boot-cli.zip -d /opt/spring-boot-cli \
    && rm -f /tmp/spring-boot-cli.zip \
    && ln -sfnv "spring-boot-cli-${spring_boot_cli_version}" /opt/spring-boot-cli/latest \
    && ln -s /opt/spring-boot-cli/latest/shell-completion/bash/spring /etc/bash_completion.d/
COPY config/spring_env.sh /etc/profile.d/spring_env.sh

# Install/upgrade ruby and jekyll
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - \
    && curl -L get.rvm.io | bash -s stable \
    && bash -l -c 'source /etc/profile.d/rvm.sh \
    && rvm reload \
    && rvm requirements run \
    && rvm install 2.4.1 \
    && rvm use 2.4.1 --default \
    && gem install jekyll bundler sass'

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash"]
