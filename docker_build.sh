#!/bin/bash

source $HOME/allvars
POPPINS_APP_PORT = 8081:8081

build() {
	echo -n ""
	echo -n "Building ${POPPINS_DOCKER_REPO} image."
	echo -n ""
	docker build -t ${POPPINS_DOCKER_REPO} .
	echo -n "Listing ${POPPINS_DOCKER_REPO} image."
	docker images
}

test () {
	echo -n "Run ${POPPINS_DOCKER_REPO} image."
	docker run --name ${POPPINS_APP_NAME} -p ${POPPINS_APP_PORT} -d ${POPPINS_DOCKER_REPO}
	echo -n "Wait until NiFi is fully started."
	sleep 15
	docker logs ${POPPINS_APP_NAME}
	echo -n "Connect to nifi using nifi-toolkit."
	#docker exec ${POPPINS_APP_NAME} /opt/nifi/nifi-toolkit-current/bin/cli.sh nifi current-user 2>/dev/null; true
}

release() {
	echo -n "Push ${POPPINS_DOCKER_REPO} image to docker registry."
	cat ${DOCKER_PWD} | docker login --username ${DOCKER_USER} --password-stdin
	docker tag  ${POPPINS_DOCKER_REPO} ${POPPINS_DOCKER_REPO}
	docker push ${POPPINS_DOCKER_REPO}
}

clean() {
	echo -n ""
	echo -n "Cleaning local build environment."
	echo -n ""
	docker stop ${POPPINS_APP_NAME} 2>/dev/null; true
	docker rm ${POPPINS_APP_NAME}  2>/dev/null; true
	echo -n ""
	echo -n "Purging local images."
	docker rmi ${POPPINS_DOCKER_REPO} 2>/dev/null; true
}

help() {
	echo -n ""
	echo -n "Please use \`make <target>' where <target> is one of"
	echo -n ""
	echo -n "  build		Builds the docker image."
	echo -n "  test		Tests image."
	echo -n "  release	Releases images."
	echo -n "  clean		Cleans local images."
	echo -n ""
	echo -n ""
}

[[ "$1" == "build" ]] && build
[[ "$1" == "test" ]] && test
[[ "$1" == "release" ]] && release
[[ "$1" == "clean" ]] && clean
[[ "$1" == "help" ]] && help
[[ "$1" == "" ]] && exit -1
