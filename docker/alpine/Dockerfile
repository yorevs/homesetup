FROM yorevs/hhs-docker-agent-python3

MAINTAINER Hugo Saporetti Junior<homesetup@gmail.com>

USER root

ENV SHELL=/bin/bash
ENV USER=root
ENV GROUP=root
ENV HOME=/root

RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
RUN ln -sf "$(command -v python3)" "$(dirname $(command -v python3))/python"

WORKDIR "/"
CMD ["bash", "--login"]
