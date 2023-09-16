FROM fedora

MAINTAINER Hugo Saporetti Junior<homesetup@gmail.com>

USER root

RUN dnf -y update
RUN dnf install -y sudo curl vim git findutils procps hostname uptimed glibc-common net-tools
RUN dnf install -y gcc postgresql-devel python3-pip python3-devel rsync bats
RUN dnf clean all
RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
RUN ln -sf "$(command -v python3)" "$(dirname $(command -v python3))/python"

WORKDIR "/"
CMD ["bash", "--login"]
