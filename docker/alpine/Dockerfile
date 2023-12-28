FROM jenkins/agent:alpine-jdk11

MAINTAINER Hugo Saporetti Junior<homesetup@gmail.com>

USER root

ENV SHELL=/bin/bash
ENV USER=jenkins
ENV GROUP=jenkins
ENV HOME=/home/jenkins

RUN apk -U upgrade
RUN apk add --no-cache python3
RUN apk add --no-cache py3-pip
RUN apk add --no-cache curl
RUN apk add --no-cache rsync
RUN apk add --no-cache ncurses
RUN apk add --no-cache ruby
RUN apk add --no-cache file
RUN apk add --no-cache gnupg
RUN apk add --no-cache bash
RUN apk add --no-cache vim
RUN ln -sf "$(command -v python3)" "$(dirname $(command -v python3))/python"

USER jenkins
WORKDIR "${HOME}"

#RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash

CMD ["bash", "--login"]
