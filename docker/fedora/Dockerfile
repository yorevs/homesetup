FROM fedora

MAINTAINER Hugo Saporetti Junior<yorevs@hotmail.com>

RUN dnf -y update
RUN dnf install -y sudo curl git findutils procps hostname uptimed glibc-common net-tools python3-pip
RUN dnf install -y gcc postgresql-devel python3-devel
RUN dnf clean all
RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
WORKDIR "/"
RUN ln -sf "$(command -v python3)" "$(dirname $(command -v python3))/python"
CMD ["bash", "--login"]
