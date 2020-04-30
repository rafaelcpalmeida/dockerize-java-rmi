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

.PHONY: run-rabbitmq-server
run-rabbitmq-server: ### Runs RabbitMQ 3.8 server instance. Web GUI on localhost:15672
	@docker-compose up rabbitmq

.PHONY: run-web-server
run-web-server: ### Runs Python 3 http.server on port 8000
	@docker-compose up webserver

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

	JAR_LOCATION=$(JAR_LOCATION) JAR_NAME=$(JAR_NAME) PACKAGE_NAME=$(PACKAGE_NAME) SERVICE_NAME=$(SERVICE_NAME) docker-compose up server

JAR_LOCATION = "empty"
JAR_NAME = "empty"
$(eval INSTANCES=`docker ps | awk -v count=1 '/rmi-client/ {count++} END{print count}'`)
.PHONY: run-client
run-client:	### Runs RMI client
ifndef PACKAGE_NAME
	$(error Missing PACKAGE_NAME variable. Usage: make run-server JAR_LOCATION (optional) JAR_NAME (optional) PACKAGE_NAME SERVICE_NAME)
endif
ifndef SERVICE_NAME
	$(error Missing SERVICE_NAME variable. Usage: make run-server JAR_LOCATION (optional) JAR_NAME (optional) PACKAGE_NAME SERVICE_NAME)
endif

	JAR_LOCATION=$(JAR_LOCATION) JAR_NAME=$(JAR_NAME) PACKAGE_NAME=$(PACKAGE_NAME) SERVICE_NAME=$(SERVICE_NAME) docker-compose up client
