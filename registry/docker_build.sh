#!/bin/bash

source $HOME/allvars
APP_PORT = 18080:18080

build() {
	echo -n ""
	echo -n "Building ${REGISTRY_DOCKER_REPO} image."
	echo -n ""
	docker build -t ${REGISTRY_DOCKER_REPO} .
	echo -n "Listing ${REGISTRY_DOCKER_REPO} image."
	docker images
}

test() {
	echo -n "Run ${REGISTRY_DOCKER_REPO} image."
	docker run --name ${REGISTRY_APP_NAME} -p ${APP_PORT} -d ${REGISTRY_DOCKER_REPO}
	echo -n "Wait until NiFi is fully started."
	sleep 15
	docker logs ${REGISTRY_APP_NAME}
}

release() {
	echo -n "Push ${REGISTRY_DOCKER_REPO} image to docker registry."
	cat ${DOCKER_PWD} | docker login --username ${DOCKER_USER} --password-stdin
	docker tag  ${REGISTRY_DOCKER_REPO} ${REGISTRY_DOCKER_REPO}
	docker push ${REGISTRY_DOCKER_REPO}
}

clean() {
	echo -n ""
	echo -n "Cleaning local build environment."
	echo -n ""
	docker stop ${REGISTRY_APP_NAME} 2>/dev/null; true
	docker rm ${REGISTRY_APP_NAME}  2>/dev/null; true
	echo -n ""
	echo -n "Purging local images."
	docker rmi ${REGISTRY_DOCKER_REPO} 2>/dev/null; true
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
