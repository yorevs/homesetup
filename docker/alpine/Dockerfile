FROM jenkins/agent:alpine-jdk11

MAINTAINER Hugo Saporetti Junior<homesetup@gmail.com>

USER root

ENV SHELL=/bin/bash
ENV USER=runner
ENV GROUP=runner
ENV HOME=/home/runner

RUN apk add python3
RUN apk add py3-pip
RUN apk add curl
RUN apk add rsync
RUN apk add ncurses
RUN apk add ruby
RUN apk add file
RUN apk add --no-cache gnupg
RUN apk add --no-cache bash
RUN ln -sf "$(command -v python3)" "$(dirname $(command -v python3))/python"
RUN adduser -D -s "${SHELL}" -h "${HOME}" -g "${GROUP}" "${USER}"

USER runner
WORKDIR "${HOME}"

RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash

CMD ["bash", "--login"]
