# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mregrag <mregrag@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/01/03 23:29:25 by mregrag           #+#    #+#              #
#    Updated: 2025/01/05 23:26:11 by mregrag          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception
DATA_PATH = /home/$(USER)/data

all: setup build

setup:
	@mkdir -p $(DATA_PATH)/wordpress
	@mkdir -p $(DATA_PATH)/mariadb

build:
	@docker-compose -f srcs/docker-compose.yml up --build -d

clean:
	@docker-compose -f srcs/docker-compose.yml down

fclean: clean
	@docker system prune -af
	@sudo rm -rf $(DATA_PATH)

re: fclean all

.PHONY: all setup build clean fclean re
