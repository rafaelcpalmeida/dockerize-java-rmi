#!/usr/bin/env bash
#@REM ************************************************************************************
#@REM Description: run HelloWorldServer
#@REM Author: Rui S. Moreira
#@REM Date: 20/02/2014
#@REM Adapted by: Rafael Almeida
#@REM Date: 21/02/2020
#@REM ************************************************************************************

mkdir -p /app/built-classes

cd /app/built-classes

cp -r /app/src/* .
cp -r /app/bin/* .

echo ""
echo "***************************************************"
echo "*  Compiling binaries. This may take some time... *"
echo "***************************************************"
echo ""

javac -cp .:amqp-client-5.9.0.jar:slf4j-api-1.7.9.jar:slf4j-simple-1.7.9.jar:/app/built-classes $(find ./* | grep .java)

echo ""
echo "***************************"
echo "*  Running application... *"
echo "***************************"
echo ""

rmiregistry &

CMD="java -cp .:amqp-client-5.9.0.jar:slf4j-api-1.7.9.jar:slf4j-simple-1.7.9.jar:/app/built-classes "

if [[ "$1" != "empty" ]] && [[ "$2" != "empty" ]]; then
    if [ "$1" == "file" ]; then
        CMD+="-Djava.rmi.server.codebase=file:////app/built-classes/$1.jar "
    else
        CMD+="-Djava.rmi.server.codebase=http://$1/$2.jar "
    fi
fi

CMD+="-Djava.rmi.server.hostname=rmi_run_server "
CMD+="-Djava.security.policy=file:////app/security-policies/serverAllPermition.policy "
CMD+="$3 rmi_run_server 1099 $4"

$CMD
