#
# Makefile for poppins on docker
#
# author: Jorge Armando Medina
# desc: Script to build, test and release the poppins docker image.

include /var/lib/jenkins/.env
include /var/lib/jenkins/apps_data

APP_PORT = 18080:18080

.PHONY: all build test release clean help

all: help

build:
	@echo ""
	@echo "Building ${REGISTRY_DOCKER_REPO} image."
	@echo ""
	docker build -t ${REGISTRY_DOCKER_REPO} .
	@echo "Listing ${REGISTRY_DOCKER_REPO} image."
	docker images

test:
	@echo "Run ${REGISTRY_DOCKER_REPO} image."
	docker run --name ${REGISTRY_APP_NAME} -p ${APP_PORT} -d ${REGISTRY_DOCKER_REPO}
	@echo "Wait until NiFi is fully started."
	sleep 15
	docker logs ${REGISTRY_APP_NAME}

release:
	@echo "Push ${REGISTRY_DOCKER_REPO} image to docker registry."
	cat ${DOCKER_PWD} | docker login --username ${DOCKER_USER} --password-stdin
	docker tag  ${REGISTRY_DOCKER_REPO} ${REGISTRY_DOCKER_REPO}
	docker push ${REGISTRY_DOCKER_REPO}

clean:
	@echo ""
	@echo "Cleaning local build environment."
	@echo ""
	docker stop ${REGISTRY_APP_NAME} 2>/dev/null; true
	docker rm ${REGISTRY_APP_NAME}  2>/dev/null; true
	@echo ""
	@echo "Purging local images."
	docker rmi ${REGISTRY_DOCKER_REPO} 2>/dev/null; true

help:
	@echo ""
	@echo "Please use \`make <target>' where <target> is one of"
	@echo ""
	@echo "  build		Builds the docker image."
	@echo "  test		Tests image."
	@echo "  release	Releases images."
	@echo "  clean		Cleans local images."
	@echo ""
	@echo ""
