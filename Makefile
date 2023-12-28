#!/bin/bash

help: ## Show this help message
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'


network: ## Create wiki-stream-network network
	docker network create wiki-stream-network || true


start: ## Start the containers
	$(MAKE) start_infrastructure && $(MAKE) start_application
	

stop: ## Stop the containers
	$(MAKE) stop_infrastructure && $(MAKE) stop_application

restart: ## Restart the containers
	$(MAKE) stop && $(MAKE) start







######## Start infrastructure containers ########


start_infrastructure: ## Start infrastructure containers
	$(MAKE) start_kafka && $(MAKE) start_db

start_kafka: ## Start Kafka container
	docker-compose -f infrastructure/kafka/docker-compose.yml up -d

start_db: ## Start Postgres container
	docker-compose -f infrastructure/db/docker-compose.yml up -d


stop_insfrastructure: ## Stop infrastructure containers
	$(MAKE) stop_kafka && $(MAKE) stop_db

stop_kafka: ## Stop Kafka container
	docker-compose -f infrastructure/kafka/docker-compose.yml down

stop_db: ## Stop Postgres container
	docker-compose -f infrastructure/db/docker-compose.yml down



######## Start application containers ########

start_application: ## Start application containers
	$(MAKE) start_producer && $(MAKE) start_consumer

start_producer: ## Start producer container
	docker-compose -f kafka-producer-wikimedia/docker-compose.yml up -d
	
start_consumer: ## Start consumer container
	docker-compose -f kafka-consumer-wikimedia/docker-compose.yml up -d	

stop_application: ## Stop application containers
	$(MAKE) stop_producer && $(MAKE) stop_consumer

stop_producer: ## Stop producer container
	docker-compose -f kafka-producer-wikimedia/docker-compose.yml down
	
stop_consumer: ## Stop consumer container
	docker-compose -f kafka-consumer-wikimedia/docker-compose.yml down	




######## Build images from Dockerfile for projects ########

build: ## Rebuilds all the containers
	$(MAKE) network && $(MAKE) build_producer && $(MAKE) build_consumer

build_producer: 
	$(MAKE) network
	docker-compose -f kafka-producer-wikimedia/docker-compose.yml build --force-rm
	
build_consumer: 
	docker-compose -f kafka-consumer-wikimedia/docker-compose.yml build --force-rm


ssh_kafka:
	docker exec -it kafka kafka-console-consumer.sh --topic wikimedia_recentchange --bootstrap-server localhost:9092



