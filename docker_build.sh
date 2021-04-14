#!/bin/bash

source $HOME/allvars
POPPINS_APP_PORT=8081:8081
VERSION=$(git rev-list --count HEAD)
REPO=${DOCKER_REPO}/${POPPINS_IMAGE_NAME}:0.5.${VERSION}
export ENVIRONMENT="stg"

all() {
	git submodule update --init --recursive
	git submodule foreach git pull --ff-only origin master
	build
	release
}

build() {
	echo -e ""
	echo -e "Building ${REPO} image."
	echo -e ""
	docker build -t ${REPO} .
	echo -e "Listing ${REPO} image."
	docker images
}

test () {
	echo -e "Run ${REPO} image."
	docker run --name ${POPPINS_IMAGE_NAME} -p ${POPPINS_APP_PORT} -d ${REPO}
	echo -e "Wait until NiFi is fully started."
	sleep 15
	docker logs ${POPPINS_IMAGE_NAME}
	echo -e "Connect to nifi using nifi-toolkit."
	#docker exec ${POPPINS_APP_NAME} /opt/nifi/nifi-toolkit-current/bin/cli.sh nifi current-user 2>/dev/null; true
}

release() {
	echo -e "Push ${REPO} image to docker registry."
	if [[ ! -z "$DOCKER_PWD" ]]; then
		cat ${DOCKER_PWD} | docker login --username ${DOCKER_USER} --password-stdin
	fi
	docker tag  ${REPO} ${REPO}
	docker push ${REPO}
}

clean() {
	echo -e ""
	echo -e "Cleaning local build environment."
	echo -e ""
	docker stop ${POPPINS_IMAGE_NAME} 2>/dev/null; true
	docker rm ${POPPINS_IMAGE_NAME}  2>/dev/null; true
	echo -e ""
	echo -e "Purging local images."
	docker rmi ${REPO} 2>/dev/null; true
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
