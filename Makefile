# <3
# https://news.ycombinator.com/item?id=11939200
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
	
.PHONY: run-server
run-server:	### Runs RMI server
ifndef JAR_NAME
override JAR_NAME = "empty"
endif
ifndef PACKAGE_NAME
	$(error Missing PACKAGE_NAME variable. Usage: make run-server JAR_NAME (optional) PACKAGE_NAME SERVICE_NAME)
endif
ifndef SERVICE_NAME
	$(error Missing SERVICE_NAME variable. Usage: make run-server JAR_NAME (optional) PACKAGE_NAME SERVICE_NAME)
endif

	@docker run -it --rm -p 1099:1099 --name=rmi_run_server --network=distributed_systems_docker_network \
        -v "$(PWD)/bin:/app/bin" \
        -v "$(PWD)/security-policies:/app/security-policies" \
        -v "$(PWD)/server:/app" \
        rmi-server bash -c "./run-server.sh $(JAR_NAME) $(PACKAGE_NAME) $(SERVICE_NAME)"
	
.PHONY: run-client
run-client:	### Runs RMI client
	@docker run -it --rm --name=rmi_run_client --network=distributed_systems_docker_network \
	-v "$(PWD)/bin:/app/bin" \
	-v "$(PWD)/security-policies:/app/security-policies" \
	-v "$(PWD)/client:/app" \
	rmi-client bash -c "./run-client.sh"
