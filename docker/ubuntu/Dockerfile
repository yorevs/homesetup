FROM ubuntu

MAINTAINER yorevs

RUN apt-get update && apt-get install -y curl locales sudo
RUN locale-gen "en_US.UTF-8"
RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
RUN echo "Type 'reload' to activate HomeSetup"
CMD ["bash", "--login"]
