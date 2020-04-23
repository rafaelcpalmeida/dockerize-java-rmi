# Java RMI Applications Dockerized
This repo is a simple boilerplate for dockerized Java RMI and, as well as Pub/Sub applications using RabbitMQ as a message broker. It's meant to work without modifications and/or customizations.

## Instructions
Given the following folder structure:
```
├── LICENSE
├── Makefile
├── README.md
├── bin
│   ├── amqp-client-5.9.0.jar
│   ├── slf4j-api-1.7.9.jar
│   └── slf4j-simple-1.7.9.jar
├── client
│   ├── Dockerfile
│   ├── run-client.sh
│   └── security-policies
├── security-policies
│   ├── client.policy
│   ├── clientAllPermition.policy
│   ├── group.policy
│   ├── rmid.policy
│   ├── serverAllPermition.policy
│   └── setup.policy
├── server
│   ├── Dockerfile
│   ├── run-server.sh
│   └── security-policies
└── src
    └── edu
        └── ufp
            └── inf
                └── sd
                    ├── rabbitmq
                    │   └── hello
                    │       ├── consumer
                    │       │   └── Consumer.java
                    │       └── producer
                    │           └── Producer.java
                    └── rmi
                        ├── test
                        │   ├── client
                        │   │   └── TestClient.java
                        │   └── server
                        │       ├── TestImpl.java
                        │       ├── TestRI.java
                        │       └── TestServer.java
                        └── util
                            ├── rmisetup
                            │   └── SetupContextRMI.java
                            └── threading
                                └── ThreadPool.java
```
All of your Java packages should be inside `src`, just like the example above has `edu.ufp.inf.sd.rmi.test`, `edu.ufp.inf.sd.rmi.util` and `edu.ufp.inf.sd.rabbitmq.hello`.

## Usage

Apps can be started using `make` command. For instance, `make run-server PACKAGE_NAME=com.your.package.YourApp SERVICE_NAME=YourService`

Before running any command you should run `make setup-environment` and `make build-all` to get everything prepared.

Bellow you can find information on how to run the given example apps.

### Test app example
To start `Test` application **server** you can execute:
`make run-server PACKAGE_NAME=edu.ufp.inf.sd.rmi.test.server.TestServer SERVICE_NAME=TestService`

To start `Test` application **client** you can execute:
`make run-client PACKAGE_NAME=edu.ufp.inf.sd.rmi.test.client.TestClient SERVICE_NAME=TestService`

### Hello RabbitMQ example
Since `RabbitMQ`-dependant applications require an instance of a `RabbitMQ` server, first, you need to run `make run-rabbitmq-server`

To start `Hello - RabbitMQ` application **consumer** you can execute:
`make run-client PACKAGE_NAME=edu.ufp.inf.sd.rabbitmq.hello.consumer.Consumer SERVICE_NAME=rabbit`

To start `Hello - RabbitMQ` application **producer** you can execute:
`make run-client PACKAGE_NAME=edu.ufp.inf.sd.rabbitmq.hello.producer.Producer SERVICE_NAME=rabbit`

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)


**Made with :heart: in Portugal**

**Software livre c\*ralho! :v:**
