FROM fedora

LABEL maintainer="Hugo Saporetti Junior<taius.hhs@gmail.com>"

USER root

ENV SHELL='/bin/bash'
ENV HOME='/root'

RUN yum -y update
RUN yum install -y sudo curl vim git findutils procps procps-ng hostname uptimed glibc-common net-tools
RUN yum install -y gcc postgresql-devel rsync file cmake ruby ruby-devel
RUN yum install -y bat fd-find fzf gawk
RUN yum install -y python3-pip python3.11-devel
RUN yum clean all
RUN gem install colorls
RUN ln -sf "/usr/bin/python3.11" "/usr/bin/python3"

WORKDIR "${HOME}"

RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash

CMD ["bash", "--login"]
