# FROM nobodyxu/apt-fast:latest-ubuntu-bionic AS base
FROM amd64/ubuntu:20.04 AS latex

ENV DEBIAN_FRONTEND noninteractive

# ユーザーを作成
ARG DOCKER_USER_=guest
ARG APT_LINK=http://ftp.riken.jp/Linux/ubuntu/
RUN sed -i "s-$(cat /etc/apt/sources.list | grep -v "#" | cut -d " " -f 2 | grep -v "security" | sed "/^$/d" | sed -n 1p)-${APT_LINK}-g" /etc/apt/sources.list

RUN apt-get update &&\
    apt-get install -y software-properties-common

RUN add-apt-repository ppa:apt-fast/stable
RUN apt-get update &&\
    apt-get install -y apt-fast &&\
    apt-get purge -y software-properties-common


ARG TS
RUN apt-fast update &&\
    apt-fast upgrade -y

USER ${DOCKER_USER_}
