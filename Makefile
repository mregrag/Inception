DOCKER_COMPOSE = srcs/docker-compose.yml
USER ?= $(shell whoami)

DATA_DIRS = /home/$(USER)/data/wordpress \
						/home/$(USER)/data/mariadb \
						/home/$(USER)/data/portainer

all: up

up: $(DATA_DIRS)
	@docker-compose -f $(DOCKER_COMPOSE) up -d --build

$(DATA_DIRS):
	@mkdir -p $@

down:
	@docker-compose -f $(DOCKER_COMPOSE) down

build:
	@docker-compose -f $(DOCKER_COMPOSE) build

clean: down
	@docker-compose -f $(DOCKER_COMPOSE) down -v --rmi all --remove-orphans
	@docker image prune -f

fclean: clean
	@sudo rm -rf /home/$(USER)/data
	@docker system prune -a -f

ps:
	@docker-compose -f $(DOCKER_COMPOSE) ps

logs:
	@docker-compose -f $(DOCKER_COMPOSE) logs


sync:
	rsync -avz --delete -e "ssh -p 4242" \
		~/Desktop/Inception/ \
		$(USER)@10.13.100.137:/home/$(USER)/Desktop/Inception/

push:
	scp -P 4242 -r ~/Desktop/Inception/ $(USER)@10.13.100.137:/home/$(USER)/Desktop

re: fclean up
