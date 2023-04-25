FROM ubuntu

MAINTAINER yorevs

RUN apt update
RUN apt install -y curl locales sudo git python3  python3-pip
RUN locale-gen "en_US.UTF-8"
RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
RUN echo "Type 'reload' to activate HomeSetup"
CMD ["bash", "--login"]
