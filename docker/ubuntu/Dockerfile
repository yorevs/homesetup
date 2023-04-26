FROM ubuntu

MAINTAINER yorevs

RUN apt-get update
RUN apt-get install -y sudo curl locales git libpq-dev python3  python3-pip
RUN locale-gen "en_US.UTF-8"
RUN echo 'To install HomeSetup type: curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash'
CMD ["bash", "--login"]
