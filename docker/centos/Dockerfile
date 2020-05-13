FROM centos

MAINTAINER yorevs

RUN yum install -y curl glibc-common
RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
CMD ["bash", "--login"]
