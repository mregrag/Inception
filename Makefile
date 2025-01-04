# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mregrag <mregrag@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/01/03 23:29:25 by mregrag           #+#    #+#              #
#    Updated: 2025/01/04 17:15:36 by mregrag          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

DC = cd src && docker compose

VOLUME_PATH = $HOME/.local/inception/data
WORDPRESS_VOLUME = $(VOLUME_PATH)/wordpress
MARIADB_VOLUME = $(VOLUME_PATH)/mariadb
DOMAIN = ${USER}.42.fr

all: setup up

setup:
	@echo "-------Creating data directories------"
	@mkdir -p  $(WORDPRESS_VOLUME)
	@mkdir -p  $(MARIADB_VOLUME)
	@chmod 777 $(WORDPRESS_VOLUME)
	@chmod 777 $(MARIADB_VOLUME)

up:
	@echo "--------Building Docker images--------"
	@$(DC) up -d

down:
	@echo "--------Stop Services--------"
	@(DC) down

clean: down
	@echo "--------Cleaning up Docker resources--------"
	@docker system prune -af
	@if [ "$$(docker volume ls -q)" ]; then \
		docker volume rm $$(docker volume ls -q); \
	fi

fclean: clean
	@echo "---- Removing all data directories----"
	@rm -rf $(VOLUME_PATH)

logs:
	@$(DC) logs -f

restart: down up

status:
	@echo "--------Docker Images--------\n"
	@docker images
	@echo "--------Docker Volumes--------\n"
	@docker volumes ls
	@echo "--------Docker Networks--------\n"
	@docker networks ls

