FROM ubuntu

LABEL maintainer="Hugo Saporetti Junior<taius.hhs@gmail.com>"

USER root

ENV SHELL='/bin/bash'
ENV HOME='/root'

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install -y sudo build-essential curl procps file vim git rsync file cmake ruby ruby-dev \
            bat fd-find fzf bsdmainutils gawk locales libpq-dev python3.11 && \
    curl -sS https://bootstrap.pypa.io/get-pip.py | python3.11 && \
    gem install colorls && \
    locale-gen "en_US.UTF-8"

RUN ln -sf "$(command -v python3.11)" "$(dirname $(command -v python3.11))/python"
RUN ln -sf "$(command -v python3.11)" "$(dirname $(command -v python3.11))/python3"

WORKDIR "${HOME}"

RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash

CMD ["bash", "--login"]
