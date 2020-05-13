FROM centos

MAINTAINER yorevs

RUN yum install -y curl glibc-common && rm -rf /var/lib/apt/lists/*
RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
RUN source ~/.bashrc
RUN __hhs_reload
