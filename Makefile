DOCKER_COMPOSE = srcs/docker-compose.yml
DATA_PATH = /home/mregrag/data

all: prepare build

prepare:
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@mkdir -p $(DATA_PATH)/redis
	@mkdir -p $(DATA_PATH)/portainer

build:
	@docker compose -f $(DOCKER_COMPOSE) up --build -d
start:
	@docker compose -f $(DOCKER_COMPOSE) start
stop:
	@docker compose -f $(DOCKER_COMPOSE) stop
ps:
	@docker compose -f $(DOCKER_COMPOSE) ps
logs:
	@docker compose -f $(DOCKER_COMPOSE) logs
clean: stop
	@docker compose -f $(DOCKER_COMPOSE) down -v
fclean: clean
	@docker system prune -af
	@rm -rf $(DATA_PATH)

restart: stop start

push:
	scp -P 4242 -r ~/Desktop/Inception/ $(USER)@10.11.100.223:/home/$(USER)/Inception

push_vm:
	scp  -r ~/Desktop/INC mregrag@148.100.79.175:/home/mregrag/Inception

re: fclean build
