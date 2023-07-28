up:
	@docker-compose -f docker-compose.yml up -d
	@chmod -R 0777 plugin || :
	@chmod -R 0777 resource || :
	@chmod -R 0777 theme || :
	@chmod -R 0777 var || :

down:
	@docker-compose -f docker-compose.yml down
