FROM jenkins/agent:alpine-jdk11
USER root
RUN apk add python3
RUN apk add py3-pip
RUN apk add bats
RUN apk add curl
RUN apk add gpg
USER jenkins
