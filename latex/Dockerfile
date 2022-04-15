FROM ubuntu:18.04

# ユーザーを作成
# ユーザ名はランチャーと依存関係にあるので変更する際はランチャー内のDOCKER_USER_NAMEも書き換えること
ARG DOCKER_USER_=null

RUN apt-get update

# パッケージインストールで参照するサーバを日本サーバに変更
# デフォルトのサーバは遠いので通信速度が遅い
RUN apt-get install -y apt-utils && apt-get install -y perl\
	&& perl -p -i.bak -e 's%(deb(?:-src|)\s+)https?://(?!archive\.canonical\.com|security\.ubuntu\.com)[^\s]+%$1http://ftp.riken.jp/Linux/ubuntu/%' /etc/apt/sources.list  \
	&& apt-get update

# ターミナルで日本語の出力を可能にするための設定
RUN apt-get install -y \
    language-pack-ja \
    bash-completion\
	gnome-terminal

RUN locale-gen ja_JP.UTF-8
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:jp
ENV LC_ALL ja_JP.UTF-8
RUN update-locale LANG=ja_JP.UTF-8

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezon

# 実行のためのパッケージ
RUN apt-get update \
&& apt-get install -y \
    make \
    evince \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-lang-cjk \
    xdvik-ja

ENV DIRPATH home/${DOCKER_USER_}
WORKDIR $DIRPATH

# ユーザ設定
RUN useradd ${DOCKER_USER_}
RUN chown -R ${DOCKER_USER_} /${DIRPATH}

USER ${DOCKER_USER_}