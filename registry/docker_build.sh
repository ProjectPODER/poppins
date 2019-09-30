#!/bin/bash

source $HOME/allvars
export ENVIRONMENT="stg"
APP_PORT=18080:18080

build() {
	echo -e ""
	echo -e "Building $REGISTRY_DOCKER_REPO image."
	docker build -t $REGISTRY_DOCKER_REPO .
	echo -e "Listing $REGISTRY_DOCKER_REPO image."
	docker images
}

test() {
	echo -e "Run ${REGISTRY_DOCKER_REPO} image."
	docker run --name ${REGISTRY_APP_NAME} -p ${APP_PORT} -d ${REGISTRY_DOCKER_REPO}
	echo -e "Wait until NiFi is fully started."
	sleep 15
	docker logs ${REGISTRY_APP_NAME}
}

release() {
	echo -e "Push ${REGISTRY_DOCKER_REPO} image to docker registry."
	#cat ${DOCKER_PWD} | docker login --username ${DOCKER_USER} --password-stdin
	docker tag  ${REGISTRY_DOCKER_REPO} ${REGISTRY_DOCKER_REPO}
docker push ${REGISTRY_DOCKER_REPO}
}

clean() {
	echo -e ""
	echo -e "Cleaning local build environment."
	echo -e ""
	docker stop ${REGISTRY_APP_NAME} 2>/dev/null; true
	docker rm ${REGISTRY_APP_NAME}  2>/dev/null; true
	echo -e ""
	echo -e "Purging local images."
	docker rmi ${REGISTRY_DOCKER_REPO} 2>/dev/null; true
}

help() {
	echo -e "USAGE\n"
	echo -e "Please use \`$0 <target>' where <target> is one of\n"
	echo -e ""
	echo -e "  build		Builds the docker image.\n"
	echo -e "  test		Tests image.\n"
	echo -e "  release	Releases images.\n"
	echo -e "  clean		Cleans local images.\n"
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
