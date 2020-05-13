FROM fedora

MAINTAINER yorevs

RUN dnf -y update && dnf install -y curl findutils procps hostname uptimed glibc-common net-tools && dnf clean all
RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
CMD ["bash", "--login"]
