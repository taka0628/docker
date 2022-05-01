NAME := latex-container
TS := `date +%Y%m%d%H%M%S`
DOCKER_USER_NAME := guest
DOCKER_HOME_DIR := /home/${DOCKER_USER_NAME}
CURRENT_PATH := $(shell pwd)

# コンテナ実行
run:
ifneq ($(shell docker ps -a | grep ${NAME}),) #起動済みのコンテナを停止
	docker container stop ${NAME}
endif
	make pre-exec_ --no-print-directory
	-docker container exec -i ${NAME} /bin/bash -c "cd semi-eco-reiwa && make all"
	-docker container exec -i ${NAME} /bin/bash -c "cd semi-eco-reiwa && make all"
	make post-exec_ --no-print-directory

# キャッシュ有りでビルド
build:
	DOCKER_BUILDKIT=1 docker image build -t ${NAME} \
	--build-arg DOCKER_USER_=${DOCKER_USER_NAME} \
	--force-rm=true .
	-docker rmi $(shell docker images -f 'dangling=true' -q)


bash:
	make pre-exec_ --no-print-directory
	-docker container exec -it ${NAME} bash
	make post-exec_ --no-print-directory

pre-exec_:
	docker container run \
	-it \
	--rm \
	-d \
	--name ${NAME} \
	${NAME}:latest
	-docker container cp semi-eco-reiwa ${NAME}:${DOCKER_HOME_DIR}
	-docker cp ~/.bashrc ${NAME}:${DOCKER_HOME_DIR}/.bashrc

post-exec_:
	-docker container cp ${NAME}:${DOCKER_HOME_DIR}/semi-eco-reiwa .
	docker container stop ${NAME}

# dockerのリソースを開放
clean:
	docker system prune

# キャッシュを使わずにビルド
rebuild:
	DOCKER_BUILDKIT=1 docker image build -t ${NAME} \
	--build-arg DOCKER_USER_=${DOCKER_USER_NAME} \
	--pull \
	--force-rm=true \
	--no-cache=true .

# root権限で起動中のコンテナに接続
connect:
	docker exec -u root -it ${NAME} /bin/bash