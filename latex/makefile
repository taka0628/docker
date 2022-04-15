NAME := guest_container
TS := `date +%Y%m%d%H%M%S`
DOCKER_USER_NAME := guest
DOCKER_HOME_DIR := /home/${DOCKER_USER_NAME}
CURRENT_PATH := $(shell pwd)

# キャッシュ有りでビルド
build:
	docker image build -t ${NAME} \
	--build-arg DOCKER_USER_=${DOCKER_USER_NAME} .

# コンテナ実行
run:
	make pre-exec_ --no-print-directory
	# -docker container exec -it ${NAME} bash
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
	-docker container exec -i ${NAME} /bin/bash -c "cd semi-eco-reiwa && make all"

post-exec_:
	-docker container cp ${NAME}:${DOCKER_HOME_DIR}/semi-eco-reiwa .
	docker container stop ${NAME}

# dockerのリソースを開放
clean:
	docker system prune

# キャッシュを使わずにビルド
rebuild:
	docker image build -t ${NAME} \
	--pull \
	--no-cache=true .

# root権限で起動中のコンテナに接続
connect:
	docker exec -u root -it ${NAME} /bin/bash