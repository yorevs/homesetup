FROM ubuntu

LABEL maintainer="Hugo Saporetti Junior<taius.hhs@gmail.com>"

USER root

ENV SHELL='/bin/bash'
ENV HOME='/home/hhs'

RUN apt-get update
RUN apt-get install -y sudo build-essential curl procps file vim git locales libpq-dev python3 python3-pip
RUN apt-get install -y rsync file cmake ruby ruby-dev bat fd-find fzf bsdmainutils gawk
RUN gem install colorls
RUN locale-gen "en_US.UTF-8"
RUN ln -sf "$(command -v python3)" "$(dirname $(command -v python3))/python"

RUN useradd -ms /bin/bash -u 1000 hhs
RUN echo "hhs ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER hhs
WORKDIR "${HOME}"

RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash

CMD ["bash", "--login"]
