DOCKER_COMPOSE = srcs/docker-compose.yml

up:
	@mkdir -p /home/$(USER)/data/wordpress
	@mkdir -p /home/$(USER)/data/mariadb
	@docker-compose -f $(DOCKER_COMPOSE) up -d --build
down:
	@docker-compose -f $(DOCKER_COMPOSE) down

build:
	@docker-compose -f $(DOCKER_COMPOSE) build

clean: down
	@docker system prune -a -f
	@docker volume rm $$(docker volume ls -q)

fclean: clean
	@sudo  rm -rf /home/$(USER)/data

ps:
	@docker-compose -f $(DOCKER_COMPOSE) ps

logs:
	@docker-compose -f $(DOCKER_COMPOSE) logs

sync:
	rsync -avz --delete -e "ssh -p 4242" \
		~/Desktop/Inception42/ \
		mohamed@10.13.100.198:/home/mohamed/Desktop/Inception/

push:
	scp -P 4242 -r /Users/mregrag/Desktop/Inception42/ mohamed@10.13.100.198:/home/mohamed/Desktop

re: fclean up
