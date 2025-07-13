GREEN = \033[0;32m
YELLOW = \033[0;33m
RESET = \033[0m

DOCKER_COMPOSE = srcs/docker-compose.yml
DATA_PATH = /home/$(USER)/data
ENV_FILE = srcs/.env

all: setup build up

setup:
	@echo "$(GREEN)Setting up data directories...$(RESET)"
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb
	@chmod 777 $(DATA_PATH)/wordpress
	@chmod 777 $(DATA_PATH)/mariadb
	@echo "$(YELLOW)Note: You may need to add the following to /etc/hosts manually:$(RESET)"
	@echo "$(YELLOW)127.0.0.1 $(USER).42.fr$(RESET)"

build:
	@echo "$(GREEN)Building Docker images...$(RESET)"
	@docker-compose -f $(DOCKER_COMPOSE) build

up:
	@echo "$(GREEN)Starting containers...$(RESET)"
	@docker-compose -f $(DOCKER_COMPOSE) up -d

down:
	@echo "$(GREEN)Stopping containers...$(RESET)"
	@docker-compose -f $(DOCKER_COMPOSE) down

clean: down
	@echo "$(GREEN)Cleaning up containers and volumes...$(RESET)"
	@docker-compose -f $(DOCKER_COMPOSE) down -v

clean-data:
	@echo "$(GREEN)Cleaning data directories with proper permissions...$(RESET)"
	@docker run --rm -v $(DATA_PATH)/mariadb:/data debian:bullseye chmod -R 777 /data
	@docker run --rm -v $(DATA_PATH)/wordpress:/data debian:bullseye chmod -R 777 /data
	@rm -rf $(DATA_PATH)/mariadb/* $(DATA_PATH)/wordpress/* 2>/dev/null || true

fclean: clean clean-data
	@echo "$(GREEN)Removing all images and volumes...$(RESET)"
	@docker system prune -af
	@rm -rf $(DATA_PATH) 2>/dev/null || true

re: fclean all

ps:
	@docker-compose -f $(DOCKER_COMPOSE) ps

logs:
	@docker-compose -f $(DOCKER_COMPOSE) logs

