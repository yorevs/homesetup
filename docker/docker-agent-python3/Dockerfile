FROM jenkins/agent:alpine-jdk11

MAINTAINER Hugo Saporetti Junior<homesetup@gmail.com>

USER root

ENV SHELL=/bin/bash

RUN apk add python3
RUN apk add py3-pip
RUN apk add curl
RUN apk add bats
RUN apk add rsync
RUN apk add ncurses
RUN apk add --no-cache gnupg
RUN apk add --no-cache bash

# Developer stuff
#RUN apk add python3-dev
#RUN apk add qt5-qtbase-dev
#RUN apk add build-base

USER jenkins
