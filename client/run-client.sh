#!/usr/bin/env bash
#@REM ************************************************************************************
#@REM Description: run HelloWorldServer
#@REM Author: Rui S. Moreira
#@REM Date: 20/02/2014
#@REM Adapted by: Rafael Almeida
#@REM Date: 21/02/2020
#@REM ************************************************************************************

cd /app/bin/classes

packageName=$(echo $3 | sed -E 's/(.[a-zA-Z0-9_]+)$//g')

CMD="java -cp .:/app/bin/classes "

if [[ "$1" != "empty" ]] && [[ "$2" != "empty" ]]; then
    if [ "$1" == "file" ]; then
        CMD+="-Djava.rmi.server.codebase=file:////app/bin/jar/$1.jar "
        CMD+="-D$packageName.codebase=file:////app/bin/jar/$1.jar "
    else
        CMD+="-Djava.rmi.server.codebase=http://$1/$2.jar "
        CMD+="-D$packageName.codebase=http://$1/$2.jar "
    fi
fi

CMD+="-Djava.security.policy=file:////app/security-policies/serverAllPermition.policy "
CMD+="-D$packageName.servicename=$3 "
CMD+="$2 rmi_run_server 1099 $3"

$CMD
