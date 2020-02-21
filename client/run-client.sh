#!/usr/bin/env bash
#@REM ************************************************************************************
#@REM Description: run HelloWorldServer
#@REM Author: Rui S. Moreira
#@REM Date: 20/02/2014
#@REM Adapted by: Rafael Almeida
#@REM Date: 18/02/2020
#@REM ************************************************************************************

cd /app/bin/classes

packageName=$(echo $2 | sed -E 's/(.[a-zA-Z0-9_]+)$//g')

CMD="java -cp .:/app/bin/classes "

if [ "$1" != "empty" ]; then
    CMD+="-Djava.rmi.server.codebase=file:////app/bin/jar/$1.jar "
    CMD+="-D$packageName.codebase=file:////app/bin/jar/$1.jar "
fi

CMD+="-Djava.security.policy=file:////app/security-policies/serverAllPermition.policy "
CMD+="-D$packageName.servicename=$3 "
CMD+="$2 rmi_run_server 1099 $3"

$CMD

#CMD+="-Djava.rmi.server.hostname=rmi_run_server "
#CMD+="-Djava.security.policy=file:////app/security-policies/serverAllPermition.policy "
#CMD+="$2 rmi_run_server 1099 $3"

#$CMD

#java -cp .:/app/bin/classes \
#-Djava.rmi.server.codebase=http://python_server:8000/SD.jar \
#-Dedu.ufp.inf.sd.rmi.test.client.codebase=http://python_server:8000/SD.jar \
#-Djava.security.policy=file:////app/security-policies/clientAllPermition.policy \
#-Dedu.ufp.inf.sd.rmi.test.servicename=TestService \
#edu.ufp.inf.sd.rmi.test.client.TestClient rmi_run_server 1099 TestService