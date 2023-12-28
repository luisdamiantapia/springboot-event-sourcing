#!/bin/bash

help: ## Show this help message
	@echo 'usage: make [target]'
	@echo
	@echo 'Targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'


network: ## Create wiki-stream-network network
	docker network create wiki-stream-network || true

start: ## Start the containers
	$(MAKE) start_infrastructure
	timeout  60
	$(MAKE) start_application
	

stop: ## Stop the containers
	$(MAKE) stop_infrastructure
	$(MAKE) stop_application

restart: ## Restart the containers
	$(MAKE) stop && $(MAKE) start







######## Start infrastructure containers ########

start_infrastructure: ## Start infrastructure containers
	$(MAKE) network
	$(MAKE) start_kafka
	$(MAKE) start_db

start_kafka: ## Start Kafka container
	$(MAKE) network
	docker-compose -f infrastructure/kafka/docker-compose.yml up -d

start_db: ## Start Postgres container
	$(MAKE) network
	docker-compose -f infrastructure/db/docker-compose.yml up -d

stop_infrastructure: ## Stop infrastructure containers
	$(MAKE) stop_kafka
	$(MAKE) stop_db

stop_kafka: ## Stop Kafka container
	docker-compose -f infrastructure/kafka/docker-compose.yml down

stop_db: ## Stop Postgres container
	docker-compose -f infrastructure/db/docker-compose.yml down



######## Start application containers ########

start_application: ## Start application containers
	$(MAKE) network
	$(MAKE) build
	$(MAKE) start_producer
	$(MAKE) start_consumer

start_producer: ## Start producer container
	$(MAKE) network
	docker-compose -f kafka-producer-wikimedia/docker-compose.yml up -d
	
start_consumer: ## Start consumer container
	$(MAKE) network
	docker-compose -f kafka-consumer-wikimedia/docker-compose.yml up -d	

stop_application: ## Stop application containers
	$(MAKE) stop_producer
	$(MAKE) stop_consumer

stop_producer: ## Stop producer container
	docker-compose -f kafka-producer-wikimedia/docker-compose.yml down
	
stop_consumer: ## Stop consumer container
	docker-compose -f kafka-consumer-wikimedia/docker-compose.yml down	

######## Build images from Dockerfile for projects ########

build: ## Build all the containers
	$(MAKE) network
	$(MAKE) build_producer
	$(MAKE) build_consumer

build_producer:
	$(MAKE) network
	$(MAKE) package
	docker-compose -f kafka-producer-wikimedia/docker-compose.yml build --force-rm

package:
	$(MAKE) package_consumer
	$(MAKE) package_producer

package_consumer:
	mvn clean package -DskipTests -f ./kafka-consumer-wikimedia/pom.xml

package_producer:
	mvn clean package -DskipTests -f ./kafka-producer-wikimedia/pom.xml


build_consumer:
	$(MAKE) network
	docker-compose -f kafka-consumer-wikimedia/docker-compose.yml build --force-rm

ssh_kafka_consumer:
	docker exec -it kafka kafka-console-consumer.sh --topic wikimedia_recentchange --bootstrap-server localhost:9092

ssh_kafka_topics:
	docker exec -it kafka kafka-topics.sh --list --bootstrap-server localhost:9092

list: ## List all containers
	docker ps -a



