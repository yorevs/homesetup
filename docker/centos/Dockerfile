FROM centos

MAINTAINER Hugo Saporetti Junior<homesetup@gmail.com>

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum update -y
RUN yum install -y sudo curl vim wget glibc-common libpq-devel git openssl-devel bzip2-devel libffi-devel
RUN yum groupinstall -y "Development Tools"
RUN wget https://www.python.org/ftp/python/3.10.2/Python-3.10.2.tgz
RUN tar -xzf Python-3.10.2.tgz
WORKDIR "Python-3.10.2"
RUN ./configure --enable-optimizations
RUN make install
RUN python3 -m pip install --upgrade pip
RUN curl -o- https://raw.githubusercontent.com/yorevs/homesetup/master/install.bash | bash
WORKDIR "/"
RUN ln -sf "$(command -v python3)" "$(dirname $(command -v python3))/python"
CMD ["bash", "--login"]
