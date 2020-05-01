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

packageName=$(echo ${PACKAGE_NAME} | sed -E 's/(.[a-zA-Z0-9_]+)$//g')

CMD="java -cp .:$JAR_TO_COMPILE:/built-classes "

if [[ "${JAR_LOCATION}" != "empty" ]] && [[ "${JAR_NAME}" != "empty" ]]; then
    if [ "${JAR_LOCATION}" == "file" ]; then
        CMD+="-Djava.rmi.server.codebase=file:////built-classes/${JAR_LOCATION}.jar "
        CMD+="-D$packageName.codebase=file:////built-classes/${JAR_LOCATION}.jar "
    else
        CMD+="-Djava.rmi.server.codebase=http://${JAR_LOCATION}/${JAR_NAME}.jar "
        CMD+="-D$packageName.codebase=http://${JAR_LOCATION}/${JAR_NAME}.jar "
    fi
fi

if [[ "${SERVICE_NAME}" != "rabbitmq" ]]; then
  attempts=0
  while ! nc -zvw3 rmi_run_server 1099; do
    sleep 3
    attempts=$((attempts + 1))

    if [[ "$attempts" -gt "10" ]]; then
      echo "Timeout while waiting for server to start"
      exit 1
    fi
  done
fi

CMD+="-Djava.security.policy=file:////app/security-policies/serverAllPermition.policy "
CMD+="-D$packageName.servicename=${SERVICE_NAME} "
CMD+="${PACKAGE_NAME} rmi_run_server 1099 ${SERVICE_NAME}"

$CMD
