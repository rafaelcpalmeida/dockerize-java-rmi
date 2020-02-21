#!/usr/bin/env sh
#@REM ************************************************************************************
#@REM Description: run HelloWorldServer
#@REM Author: Rui S. Moreira
#@REM Date: 20/02/2014
#@REM Adapted by: Rafael Almeida
#@REM Date: 18/02/2020
#@REM ************************************************************************************

cd /app/bin

rmiregistry &

java -cp .:/app/bin/ \
-Djava.rmi.server.codebase=http://python_server:8000/SD.jar \
-Djava.rmi.server.hostname=rmi_run_server \
-Djava.security.policy=file:////app/security-policies/serverAllPermition.policy \
edu.ufp.inf.sd.rmi.test.server.TestServer rmi_run_server 1099 TestService

