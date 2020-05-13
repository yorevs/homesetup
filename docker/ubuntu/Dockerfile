FROM ubuntu

MAINTAINER yorevs

RUN apt-get update && apt-get install -y curl
RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
CMD ["bash", "--login"]
