# Inception Project Makefile

NAME = inception
DOCKER_COMPOSE_FILE = srcs/docker-compose.yml

all: up

up:
	@printf "Starting $(NAME)...\n"
	@mkdir -p /home/$(USER)/data/wordpress
	@mkdir -p /home/$(USER)/data/mariadb
	@docker-compose -f $(DOCKER_COMPOSE_FILE) up -d --build

down:
	@printf "Stopping $(NAME)...\n"
	@docker-compose -f $(DOCKER_COMPOSE_FILE) down

build:
	@echo "$(GREEN)Building Docker images...$(RESET)"
	@docker-compose -f $(DOCKER_COMPOSE) build

clean: down
	@printf "Cleaning $(NAME)...\n"
	@docker system prune -a -f
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true

fclean: clean
	@printf "Full cleaning $(NAME)...\n"
	@sudo rm -rf /home/$(USER)/data

ps:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) ps

logs:
	@docker-compose -f $(DOCKER_COMPOSE_FILE) logs


sync:
	rsync -avz --delete -e "ssh -p 4242" \
		~/Desktop/Inception/ \
		mregrag@localhost:/home/mregrag/Desktop/Inception/

push:
	scp -P 4242 -r /Users/mregrag/Desktop/Inception mregrag@localhost:/home/mregrag/Desktop

re: fclean all

