# FROM nobodyxu/apt-fast:latest-ubuntu-bionic AS base
FROM amd64/ubuntu:20.04 AS latex

ENV DEBIAN_FRONTEND noninteractive

# ユーザーを作成
ARG DOCKER_USER_=guest
ARG APT_LINK=http://ftp.riken.jp/Linux/ubuntu/
RUN sed -i "s-$(cat /etc/apt/sources.list | grep -v "#" | cut -d " " -f 2 | grep -v "security" | sed "/^$/d" | sed -n 1p)-${APT_LINK}-g" /etc/apt/sources.list

RUN apt-get -q update &&\
    apt-get -q install gcc make

WORKDIR /home/${DOCKER_USER_}

RUN useradd ${DOCKER_USER_}\
	&& chown -R ${DOCKER_USER_} /home/${DOCKER_USER_}

USER ${DOCKER_USER_}
