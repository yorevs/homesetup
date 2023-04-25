FROM fedora

MAINTAINER yorevs

RUN dnf -y update
RUN dnf install -y curl sudo git findutils procps hostname uptimed glibc-common net-tools
RUN dnf clean all
RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
RUN echo "Type 'reload' to activate HomeSetup"
CMD ["bash", "--login"]
