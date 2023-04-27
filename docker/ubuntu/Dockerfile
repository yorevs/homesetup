FROM ubuntu

MAINTAINER Hugo Saporetti Junior<yorevs@hotmail.com>

RUN apt-get update
RUN apt-get install -y sudo curl locales git libpq-dev python3  python3-pip
RUN locale-gen "en_US.UTF-8"
RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
WORKDIR "/"
RUN ln -sf "$(command -v python3)" "$(dirname $(command -v python3))/python"
CMD ["bash", "--login"]
