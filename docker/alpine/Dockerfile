FROM jenkins/agent:alpine-jdk11

LABEL maintainer="Hugo Saporetti Junior<taius.hhs@gmail.com>"

USER root

ENV SHELL='/bin/bash'
ENV HOME='/root'

# Enable edge repositories and install python3.11
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update
RUN apk add --no-cache python3.11
RUN apk -U upgrade
RUN apk add --no-cache python3.11
RUN apk add --no-cache py3-pip
RUN apk add --no-cache curl
RUN apk add --no-cache rsync
RUN apk add --no-cache ncurses
RUN apk add --no-cache ruby
RUN apk add --no-cache file
RUN apk add --no-cache gnupg
RUN apk add --no-cache bash
RUN apk add --no-cache vim
RUN apk add --no-cache fd
RUN apk add --no-cache bat
RUN apk add --no-cache cmake
RUN apk add --no-cache fzf
RUN apk add --no-cache ruby-dev
RUN apk add --no-cache build-base
RUN gem update --system
RUN gem install rdoc colorls
RUN ln -sf "$(command -v python3)" "$(dirname $(command -v python3))/python"

WORKDIR "${HOME}"

RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash

CMD ["bash", "--login"]
