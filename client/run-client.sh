#!/usr/bin/env sh
#@REM ************************************************************************************
#@REM Description: run HelloWorldServer
#@REM Author: Rui S. Moreira
#@REM Date: 20/02/2014
#@REM Adapted by: Rafael Almeida
#@REM Date: 18/02/2020
#@REM ************************************************************************************

cd /app/bin

java -cp .:/app/bin/ \
-Djava.rmi.server.codebase=http://python_server:8000/SD.jar \
-Dedu.ufp.inf.sd.rmi.test.client.codebase=http://python_server:8000/SD.jar \
-Djava.security.policy=file:////app/security-policies/clientAllPermition.policy \
-Dedu.ufp.inf.sd.rmi.test.servicename=TestService \
edu.ufp.inf.sd.rmi.test.client.TestClient rmi_run_server 1099 TestService