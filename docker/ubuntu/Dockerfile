FROM ubuntu

MAINTAINER Hugo Saporetti Junior<homesetup@gmail.com>

USER root

RUN apt-get update
RUN apt-get install -y sudo build-essential curl procps file vim git locales libpq-dev python3 python3-pip rsync bats
RUN locale-gen "en_US.UTF-8"
RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
RUN ln -sf "$(command -v python3)" "$(dirname $(command -v python3))/python"

WORKDIR "/"
CMD ["bash", "--login"]
