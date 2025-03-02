FROM python:3.11-alpine

LABEL maintainer="Hugo Saporetti Junior<taius.hhs@gmail.com>"

USER root

ENV SHELL='/bin/bash'
ENV HOME='/root'
ENV PYTHONUNBUFFERED=1

# Enable edge repositories and install python3.11
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update && apk upgrade

RUN ln -sf "$(command -v python3.11)" "$(dirname $(command -v python3))/python3"

RUN apk add --no-cache git
RUN apk add --no-cache build-base
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
RUN apk add --no-cache fzf
RUN apk add --no-cache ruby-dev
RUN $(command -v python3.11) -m pip install --no-cache --upgrade --break-system-packages setuptools
RUN apk -U upgrade
RUN gem update --system
RUN gem install rdoc colorls

WORKDIR "${HOME}"

RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash

CMD ["bash", "--login"]
