#
# Makefile for poppins on docker
#
# author: Jorge Armando Medina
# desc: Script to build, test and release the poppins docker image.

include /var/lib/jenkins/.env
include /var/lib/jenkins/apps_data

POPPINS_APP_PORT = 8081:8081

.PHONY: all build test release clean help

all: help

build:
	@echo ""
	@echo "Building ${POPPINS_DOCKER_REPO} image."
	@echo ""
	docker build -t ${POPPINS_DOCKER_REPO} .
	@echo "Listing ${POPPINS_DOCKER_REPO} image."
	docker images

test:
	@echo "Run ${POPPINS_DOCKER_REPO} image."
	docker run --name ${POPPINS_APP_NAME} -p ${POPPINS_APP_PORT} -d ${POPPINS_DOCKER_REPO}
	@echo "Wait until NiFi is fully started."
	sleep 90
	docker logs ${POPPINS_APP_NAME}
	@echo "Connect to nifi using nifi-toolkit."
	docker exec ${POPPINS_APP_NAME} /opt/nifi/nifi-toolkit-current/bin/cli.sh nifi current-user 2>/dev/null; true

release:
	@echo "Push ${POPPINS_DOCKER_REPO} image to docker registry."
	cat ${DOCKER_PWD} | docker login --username ${DOCKER_USER} --password-stdin
	docker tag  ${POPPINS_DOCKER_REPO} ${POPPINS_DOCKER_REPO}
	docker push ${POPPINS_DOCKER_REPO}

clean:
	@echo ""
	@echo "Cleaning local build environment."
	@echo ""
	docker stop ${POPPINS_APP_NAME} 2>/dev/null; true
	docker rm ${POPPINS_APP_NAME}  2>/dev/null; true
	@echo ""
	@echo "Purging local images."
	docker rmi ${POPPINS_DOCKER_REPO} 2>/dev/null; true

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
