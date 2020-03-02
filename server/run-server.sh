#!/usr/bin/env bash
#@REM ************************************************************************************
#@REM Description: run HelloWorldServer
#@REM Author: Rui S. Moreira
#@REM Date: 20/02/2014
#@REM Adapted by: Rafael Almeida
#@REM Date: 21/02/2020
#@REM ************************************************************************************

cd /app/bin/classes

rmiregistry &

CMD="java -cp .:/app/bin/classes "

if [[ "$1" != "empty" ]] && [[ "$2" != "empty" ]]; then
    if [ "$1" == "file" ]; then
        CMD+="-Djava.rmi.server.codebase=file:////app/bin/jar/$1.jar "
    else
        CMD+="-Djava.rmi.server.codebase=http://$1/$2.jar "
    fi
fi

CMD+="-Djava.rmi.server.hostname=rmi_run_server "
CMD+="-Djava.security.policy=file:////app/security-policies/serverAllPermition.policy "
CMD+="$3 rmi_run_server 1099 $4"

$CMD
