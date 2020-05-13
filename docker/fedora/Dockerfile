FROM fedora

MAINTAINER yorevs

RUN dnf -y update && dnf install -y curl sudo findutils procps hostname uptimed glibc-common net-tools && dnf clean all
RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
RUN echo "Type 'reload' to activate HomeSetup"
CMD ["bash", "--login"]
