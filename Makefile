#
# Makefile for poppins on docker
#
# author: Jorge Armando Medina
# desc: Script to build the poppins docker images using docker build.

include /var/lib/jenkins/.env

ORG_NAME = poder
APP_NAME = poppins
APP_PORT = 8081:8081
APP_VERSION = 0.2
IMAGE_NAME = ${ORG_NAME}/${APP_NAME}:${APP_VERSION}
REGISTRY_URL = localhost:5000

.PHONY: all build test clean purge help

all: help

build:
	@echo ""
	@echo "Building ${IMAGE_NAME} image."
	@echo ""
	docker build -t ${IMAGE_NAME} .
	@echo "Listing ${IMAGE_NAME} image."
	docker images

test:
	@echo "Run ${IMAGE_NAME} image."
	docker run --name ${APP_NAME} -p ${APP_PORT} -d ${IMAGE_NAME}
	@echo "Wait until NiFi is fully started."
	sleep 90
	docker logs ${APP_NAME}
	@echo "Connect to nifi using nifi-toolkit."
	docker exec ${APP_NAME} /opt/nifi/nifi-toolkit-current/bin/cli.sh nifi current-user 2>/dev/null; true

release:
	@echo "Push ${IMAGE_NAME} image to dockerhub."
	cat ${DOCKER_PWD} | docker login --username ${DOCKER_USER} --password-stdin
	docker tag  ${IMAGE_NAME} ${DOCKER_REPO}:${APP_NAME}-${APP_VERSION}
	docker push ${DOCKER_REPO}:${APP_NAME}-${APP_VERSION}

clean:
	@echo ""
	@echo "Cleaning local build environment."
	@echo ""
	docker stop ${APP_NAME} 2>/dev/null; true
	docker rm ${APP_NAME}  2>/dev/null; true
	@echo ""
	docker rmi ${IMAGE_NAME} 2>/dev/null; true

purge:
	@echo ""
	@echo "Purging local images."
	@echo ""
	docker rmi ${IMAGE_NAME}

help:
	@echo ""
	@echo "Please use \`make <target>' where <target> is one of"
	@echo ""
	@echo "  build		Builds the docker image."
	@echo "  test			Test image."
	@echo "  clean		Cleans local images."
	@echo "  purge		Purges local images."
	@echo "  release	releases local images."
	@echo ""
	@echo ""
