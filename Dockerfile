# FROM nobodyxu/apt-fast:latest-ubuntu-bionic AS base
FROM amd64/ubuntu:20.04 AS latex

ENV DEBIAN_FRONTEND noninteractive
# ユーザーを作成
ARG DOCKER_USER_=null

RUN sed -i "s-$(cat /etc/apt/sources.list | grep -v "#" | cut -d " " -f 2 | grep -v "security" | sed "/^$/d" | sed -n 1p)-http://ftp.riken.jp/Linux/ubuntu/-g" /etc/apt/sources.list

# ターミナルで日本語の出力を可能にするための設定
RUN apt-get update \
	&&  apt-get install -y language-pack-ja-base
RUN apt-get install -y wget
RUN apt-get install -y make
RUN apt-get install -y gcc
RUN apt-get install -y perl
RUN apt-get install -y g++


ARG TS=null
RUN apt-get update &&\
	apt-get upgrade -y

USER ${DOCKER_USER_}