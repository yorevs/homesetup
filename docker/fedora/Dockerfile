FROM fedora

LABEL maintainer="Hugo Saporetti Junior<taius.hhs@gmail.com>"

USER root

ENV SHELL='/bin/bash'
ENV HOME='/root'

RUN yum -y update && \
    yum install -y sudo curl vim git findutils procps procps-ng hostname uptimed glibc-common net-tools \
        gcc postgresql-devel python3.11-pip python3.11-devel rsync file cmake ruby ruby-devel bat fd-find fzf && \
    yum clean all && \
    gem install colorls
RUN ln -sf "$(command -v python3.11)" "$(dirname $(command -v python3.11))/python"
RUN ln -sf "$(command -v python3.11)" "$(dirname $(command -v python3.11))/python3"

WORKDIR "${HOME}"

RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash

CMD ["bash", "--login"]
