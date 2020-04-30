#!/usr/bin/env bash
#@REM ************************************************************************************
#@REM Description: run HelloWorldServer
#@REM Author: Rui S. Moreira
#@REM Date: 20/02/2014
#@REM Adapted by: Rafael Almeida
#@REM Date: 21/02/2020
#@REM ************************************************************************************

rm -rf /built-classes
mkdir -p /built-classes

cd /built-classes

cp -r /app/src/* .
cp -r /app/bin/* .

echo ""
echo "***************************************************"
echo "*  Compiling binaries. This may take some time... *"
echo "***************************************************"
echo ""

rmiregistry &

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

CMD="java -cp .:$JAR_TO_COMPILE:/built-classes "

if [[ "${JAR_LOCATION}" != "empty" ]] && [[ "${JAR_NAME}" != "empty" ]]; then
    if [ "${JAR_LOCATION}" == "file" ]; then
        CMD+="-Djava.rmi.server.codebase=file:////built-classes/${JAR_LOCATION}.jar "
    else
        CMD+="-Djava.rmi.server.codebase=http://${JAR_LOCATION}/${JAR_NAME}.jar "
    fi
fi

CMD+="-Djava.rmi.server.hostname=rmi_run_server "
CMD+="-Djava.security.policy=file:////app/security-policies/serverAllPermition.policy "
CMD+="${PACKAGE_NAME} rmi_run_server 1099 ${SERVICE_NAME}"

$CMD
