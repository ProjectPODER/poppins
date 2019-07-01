#
# Makefile for poppins on docker
#
# author: Jorge Armando Medina
# desc: Script to build the poppins docker images using docker build.

ORG_NAME = poder
APP_NAME = poppins
APP_PORT = 8080
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
	@echo ""
	@echo "Listing ${IMAGE_NAME} image."
	@echo ""
	docker images

test:
	@echo ""
	@echo "Run ${IMAGE_NAME} image."
	@echo ""
	docker run --name ${APP_NAME} -p ${APP_PORT}:${APP_PORT} -d ${IMAGE_NAME}
	@echo ""
	@echo "Wait until NiFi is fully started."
	sleep 60
	docker logs ${APP_NAME}
	@echo "Connect to nifi using nifi-toolkit."
	docker exec -ti ${APP_NAME} /opt/nifi/nifi-toolkit-current/bin/cli.sh nifi current-user

clean:
	@echo ""
	@echo "Cleaning local build environment."
	@echo ""
	docker stop ${APP_NAME}
	docker rm ${APP_NAME}

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
	@echo "  test		Test image."
	@echo "  clean		Cleans local images."
	@echo "  purge		Purges local images."
	@echo ""
	@echo ""
