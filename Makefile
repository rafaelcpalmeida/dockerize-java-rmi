# <3
.PHONY: help
help:	### this screen. Keep it first target to be default
ifeq ($(UNAME), Linux)
	@grep -P '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
else
	@# this is not tested, but prepared in advance for you, Mac drivers
	@awk -F ':.*###' '$$0 ~ FS {printf "%15s%s\n", $$1 ":", $$2}' \
		$(MAKEFILE_LIST) | grep -v '@awk' | sort
endif

.PHONY: setup-environment
setup-environment:	### Creates required docker network
	$(info Going to create distributed_systems_docker_network docker network...)
	@docker network create distributed_systems_docker_network

.PHONY: build-all
build-all: build-server	build-client	### Builds RMI Server and Client images

.PHONY: build-server
build-server:	### Build RMI Server image
	@docker build server/ -t rmi-server

.PHONY: build-client
build-client:	### Build RMI Client image
	@docker build client/ -t rmi-client

.PHONY: run-rabbitmq-server
run-rabbitmq-server: ### Runs RabbitMQ 3.8 server instance. Web GUI on localhost:15672
	@docker run -it --rm -p 15672:15672 --name=rmi_rabbit_mq_server --network=distributed_systems_docker_network \
	rabbitmq:3.8-management

.PHONY: run-web-server
run-web-server: ### Runs Python 3 http.server on port 8000
	@docker run -it --rm -p 8000:8000 --name=rmi_python_server --network=distributed_systems_docker_network \
	--workdir="/app/bin" -v "$(PWD)/bin:/app/bin" \
	python:3.8 bash -c "python -m http.server 8000"

JAR_LOCATION = "empty"
JAR_NAME = "empty"
.PHONY: run-server
run-server:	### Runs RMI server
ifndef PACKAGE_NAME
	$(error Missing PACKAGE_NAME variable. Usage: make run-server JAR_LOCATION (optional) JAR_NAME (optional) PACKAGE_NAME SERVICE_NAME)
endif
ifndef SERVICE_NAME
	$(error Missing SERVICE_NAME variable. Usage: make run-server JAR_LOCATION (optional) JAR_NAME (optional) PACKAGE_NAME SERVICE_NAME)
endif
	@docker run -it --rm -p 1099:1099 --name=rmi_run_server --network=distributed_systems_docker_network \
        -v "$(PWD)/bin:/app/bin" \
        -v "$(PWD)/src:/app/src" \
        -v "$(PWD)/security-policies:/app/security-policies" \
        -v "$(PWD)/server:/app" \
		--env JAR_LOCATION=$(JAR_LOCATION) \
		--env JAR_NAME=$(JAR_NAME) \
		--env PACKAGE_NAME=$(PACKAGE_NAME) \
		--env SERVICE_NAME=$(SERVICE_NAME) \
        rmi-server bash -c "reflex -s -r '\.java$$' -- sh -c 'sleep 1; /app/run-server.sh'"

JAR_LOCATION = "empty"
JAR_NAME = "empty"
.PHONY: run-client
run-client:	### Runs RMI client
ifndef PACKAGE_NAME
	$(error Missing PACKAGE_NAME variable. Usage: make run-server JAR_LOCATION (optional) JAR_NAME (optional) PACKAGE_NAME SERVICE_NAME)
endif
ifndef SERVICE_NAME
	$(error Missing SERVICE_NAME variable. Usage: make run-server JAR_LOCATION (optional) JAR_NAME (optional) PACKAGE_NAME SERVICE_NAME)
endif

	JAR_LOCATION=$(JAR_LOCATION) JAR_NAME=$(JAR_NAME) PACKAGE_NAME=$(PACKAGE_NAME) SERVICE_NAME=$(SERVICE_NAME) docker-compose run client
