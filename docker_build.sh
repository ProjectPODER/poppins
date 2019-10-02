#!/bin/bash

source $HOME/allvars
POPPINS_APP_PORT=8081:8081
export ENVIRONMENT="stg"

build() {
	echo -e ""
	echo -e "Building ${POPPINS_DOCKER_REPO} image."
	echo -e ""
	docker build -t ${POPPINS_DOCKER_REPO} .
	echo -e "Listing ${POPPINS_DOCKER_REPO} image."
	docker images
}

test () {
	echo -e "Run ${POPPINS_DOCKER_REPO} image."
	docker run --name ${POPPINS_APP_NAME} -p ${POPPINS_APP_PORT} -d ${POPPINS_DOCKER_REPO}
	echo -e "Wait until NiFi is fully started."
	sleep 15
	docker logs ${POPPINS_APP_NAME}
	echo -e "Connect to nifi using nifi-toolkit."
	#docker exec ${POPPINS_APP_NAME} /opt/nifi/nifi-toolkit-current/bin/cli.sh nifi current-user 2>/dev/null; true
}

release() {
	echo -e "Push ${POPPINS_DOCKER_REPO} image to docker registry."
	if [[ ! -z "$DOCKER_PWD" ]]; then
		cat ${DOCKER_PWD} | docker login --username ${DOCKER_USER} --password-stdin
	fi
	docker tag  ${POPPINS_DOCKER_REPO} ${POPPINS_DOCKER_REPO}
	docker push ${POPPINS_DOCKER_REPO}
}

clean() {
	echo -e ""
	echo -e "Cleaning local build environment."
	echo -e ""
	docker stop ${POPPINS_APP_NAME} 2>/dev/null; true
	docker rm ${POPPINS_APP_NAME}  2>/dev/null; true
	echo -e ""
	echo -e "Purging local images."
	docker rmi ${POPPINS_DOCKER_REPO} 2>/dev/null; true
}

help() {
	echo -e ""
	echo -e "Please use \`make <target>' where <target> is one of"
	echo -e ""
	echo -e "  build		Builds the docker image."
	echo -e "  test		Tests image."
	echo -e "  release	Releases images."
	echo -e "  clean		Cleans local images."
	echo -e ""
	echo -e ""
}

if [[ "$1" == "build" ]]; then build;
elif [[ "$1" == "test" ]]; then test;
elif [[ "$1" == "release" ]];then release;
elif [[ "$1" == "clean" ]]; then clean;
elif [[ "$1" == "help" ]];then help;
else
	help
	exit -1
fi
