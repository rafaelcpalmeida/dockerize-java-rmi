#!/usr/bin/env bash
#@REM ************************************************************************************
#@REM Description: run HelloWorldServer
#@REM Author: Rui S. Moreira
#@REM Date: 20/02/2014
#@REM Adapted by: Rafael Almeida
#@REM Date: 21/02/2020
#@REM ************************************************************************************

mkdir -p /built-classes

cd /built-classes

cp -r /app/src/* .
cp -r /app/bin/* .

echo ""
echo "***************************************************"
echo "*  Compiling binaries. This may take some time... *"
echo "***************************************************"
echo ""

JARS="$(find ./* | grep .jar)"

for JAR in $JARS
do
	JAR_TO_COMPILE+="$JAR:"
done

javac -cp .:$JAR_TO_COMPILE:/built-classes $(find ./* | grep .java)

echo ""
echo "***************************"
echo "*  Running application... *"
echo "***************************"
echo ""

packageName=$(echo $3 | sed -E 's/(.[a-zA-Z0-9_]+)$//g')

CMD="java -cp .:$JAR_TO_COMPILE:/built-classes "

if [[ "$1" != "empty" ]] && [[ "$2" != "empty" ]]; then
    if [ "$1" == "file" ]; then
        CMD+="-Djava.rmi.server.codebase=file:////built-classes/$1.jar "
        CMD+="-D$packageName.codebase=file:////built-classes/$1.jar "
    else
        CMD+="-Djava.rmi.server.codebase=http://$1/$2.jar "
        CMD+="-D$packageName.codebase=http://$1/$2.jar "
    fi
fi

CMD+="-Djava.security.policy=file:////app/security-policies/serverAllPermition.policy "
CMD+="-D$packageName.servicename=$4 "
CMD+="$3 rmi_run_server 1099 $4"

$CMD
