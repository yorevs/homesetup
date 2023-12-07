FROM fedora

MAINTAINER Hugo Saporetti Junior<homesetup@gmail.com>

USER root

RUN yum -y update
RUN yum install -y sudo curl vim git findutils procps procps-ng hostname uptimed glibc-common net-tools
RUN yum install -y gcc postgresql-devel python3-pip python3-devel rsync file ruby
RUN yum clean all
RUN ln -sf "$(command -v python3)" "$(dirname $(command -v python3))/python"
RUN useradd -ms /bin/bash runner

USER runner
WORKDIR "/home/runner"

RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash

CMD ["bash", "--login"]
