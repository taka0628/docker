# コンテナ名
NAME := actions-test

DOCKER_USER_NAME := guest
DOCKER_HOME_DIR := /home/${DOCKER_USER_NAME}
CURRENT_PATH := $(shell pwd)
TS := $(shell date +%Y%m%d%H%M%S)




# コンテナのビルド
build:
	DOCKER_BUILDKIT=1 docker image build -t ${NAME} \
	--build-arg DOCKER_USER_=${DOCKER_USER_NAME} \
	--build-arg TS=${TS} \
	--force-rm=true .
ifneq ($(shell docker images -f 'dangling=true' -q),)
	-docker rmi $(shell docker images -f 'dangling=true' -q)
endif


# キャッシュを使わずにビルド
rebuild:
	DOCKER_BUILDKIT=1 docker image build -t ${NAME} \
	--build-arg DOCKER_USER_=${DOCKER_USER_NAME} \
	--pull \
	--force-rm=true \
	--no-cache=true .

# コンテナを開きっぱなしにする
# リモートアクセス用
bash:
	make pre-exec_ --no-print-directory
	-docker container exec -it ${NAME} bash
	make post-exec_ --no-print-directory

# コンテナ実行する際の前処理
# 起動，ファイルのコピーを行う
preExec_:
ifeq ($(shell docker ps -a | grep -c ${NAME}),0)
	docker container run \
	-it \
	--rm \
	--network none \
	-d \
	--name ${NAME} \
	${NAME}:latest
endif
ifeq (${IS_LINUX},Linux)
	-docker cp ~/.bashrc ${NAME}:${DOCKER_HOME_DIR}/.bashrc
endif

# コンテナ終了時の後処理
# コンテナ内のファイルをローカルへコピー，コンテナの削除を行う
postExec_:
	docker container stop ${NAME}

# dockerのリソースを開放
clean:
	yes | docker system prune

# root権限で起動中のコンテナに接続
# aptパッケージのインストールをテストする際に使用
root:
	make pre-exec_ --no-print-directory
	-docker container exec -it --user root ${NAME} bash
	make post-exec_ --no-print-directory

stop:
ifneq ($(shell docker container ls -a | grep -c "${NAME}"),0)
	@docker container stop ${NAME}
	@echo "コンテナを停止"
endif
	@docker container ls -a

save:
	docker save ${NAME} -o ${NAME}.tar

load:
	docker load < ${NAME}.tar

# コマンドのテスト用
test:
	make preExec_ -s
	-docker container exec -it ${NAME} bash -c "echo hogeInDocker"
	make postExec_ -s

