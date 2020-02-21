# Java RMI Applications Dockerized

This repo is a simple boilerplate for dockerized Java RMI applications.

## Instructions
Given the following folder structure:
```
├── LICENSE
├── Makefile
├── README.md
├── bin
│   ├── classes
│   │   └── edu
│   │       └── ufp
│   │           └── inf
│   │               └── sd
│   │                   └── rmi
│   │                       ├── helloworld
│   │                       │   ├── client
│   │                       │   │   └── HelloWorldClient.class
│   │                       │   └── server
│   │                       │       ├── HelloWorldActivatableImpl.class
│   │                       │       ├── HelloWorldImpl.class
│   │                       │       ├── HelloWorldRI.class
│   │                       │       ├── HelloWorldServer.class
│   │                       │       ├── HelloWorldSetup.class
│   │                       │       └── ReadmeHowTo.txt
│   │                       ├── test
│   │                       │   ├── client
│   │                       │   │   └── TestClient.class
│   │                       │   └── server
│   │                       │       ├── TestImpl.class
│   │                       │       ├── TestRI.class
│   │                       │       └── TestServer.class
│   │                       └── util
│   │                           ├── rmisetup
│   │                           │   └── SetupContextRMI.class
│   │                           └── threading
│   │                               ├── ThreadPool$1.class
│   │                               ├── ThreadPool$PoolThread.class
│   │                               └── ThreadPool.class
│   └── jar
├── client
│   ├── Dockerfile
│   └── run-client.sh
├── security-policies
│   ├── client.policy
│   ├── clientAllPermition.policy
│   ├── group.policy
│   ├── rmid.policy
│   ├── serverAllPermition.policy
│   └── setup.policy
└── server
    ├── Dockerfile
    └── run-server.sh
```
All of your compiled Java classes should be inside `bin/classes`

## Usage

Apps can be started using `make` command. For instance, `make run-server PACKAGE_NAME=com.your.package.YourApp SERVICE_NAME=YourService`

Before running any command you should run `make setup-environment` and `make build-all` to get everything prepared.

Bellow you can find information on how to run the given example apps.

### Hello World app example
To start `HelloWorld` application **server** you can execute:
`make run-server PACKAGE_NAME=edu.ufp.inf.sd.rmi.helloworld.server.HelloWorldServer SERVICE_NAME=HelloWorldService`

To start `HelloWorld` application **client** you can execute:
`make run-client PACKAGE_NAME=edu.ufp.inf.sd.rmi.helloworld.client.HelloWorldClient SERVICE_NAME=HelloWorldService`

### Test app example
To start `Test` application **server** you can execute:
`make run-server PACKAGE_NAME=edu.ufp.inf.sd.rmi.test.server.TestServer SERVICE_NAME=TestService`

To start `Test` application **client** you can execute:
`make run-client PACKAGE_NAME=edu.ufp.inf.sd.rmi.test.client.TestClient SERVICE_NAME=TestService`

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
[MIT](https://choosealicense.com/licenses/mit/)


**Made with :heart: in Portugal**

**Software livre c\*ralho! :v:**
