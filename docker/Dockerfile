FROM centos

MAINTAINER yorevs

RUN yum install -y curl && rm -rf /var/lib/apt/lists/*
RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
CMD ["exec", "bash", "reload"]
