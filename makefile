NAME := guest_container
TS := `date +%Y%m%d%H%M%S`
SCORE_FILE := score.csv
DOCKER_USER_NAME := guest
DOCKER_HOME_DIR := /home/${DOCKER_USER_NAME}
CURRENT_PATH := $(shell pwd)
RescueSRC := RIORescue

# キャッシュ有りでビルド
build:
	docker image build -t ${NAME} \
	--build-arg CACHEBUST=${TS} \
	--build-arg DOCKER_USER_=${DOCKER_USER_NAME} .

# コンテナ実行
run:
	docker container run \
	-it \
	--rm \
	-d \
	--name ${NAME} \
	${NAME}:latest
	-docker container cp ../../prime_search ${NAME}:${DOCKER_HOME_DIR}
	-docker container exec -it ${NAME} bash
	docker container stop ${NAME}


# dockerのリソースを開放
clean:
	docker system prune

# キャッシュを使わずにビルド
rebuild:
	@echo "コンテナの再構築には時間がかかります"
	@echo "コンテナを再構築しますか？ (y/n)"
	@read -p "->" ans;\
	if [ "$$ans" != y ]; then  \
      exit 1;\
    fi
	docker image build -t ${NAME} \
	--build-arg CACHEBUST=${TS} \
	--pull \
	--no-cache=true .

# root権限で起動中のコンテナに接続
connect:
	docker exec -u root -it ${NAME} /bin/bash
