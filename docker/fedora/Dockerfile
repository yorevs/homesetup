FROM fedora

MAINTAINER yorevs

RUN dnf -y update
RUN dnf install -y sudo curl git findutils procps hostname uptimed glibc-common net-tools python3-pip
RUN dnf install -y gcc postgresql-devel python3-devel
RUN dnf clean all
RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
RUN echo "Type 'reload' to activate HomeSetup"
CMD ["bash", "--login"]
