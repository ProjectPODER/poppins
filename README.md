# Poppins

## Introduction

Poppins is an Apache NiFi based data pipeline for the QuienEsQuien.wiki project.

### Objetives

This readme describes the following processes:

* Build
* Test
* Deploy

## Build

To build a new poppins image with the latest changes from this repo, use the
following command to build and tag this container:

```shell
$ docker build . -t poder/poppins:0.1
```

Use `docker images` to list local images.

### Dependencies

The Dockerfile included have instructions to setup the follow dependencies:

* nodejs
* yarn
* python
* perl
* git

## Test

To run this new poppins image, use the following command:

```shell
$ docker run -p 8080:8080 poder/poppins:0.1
```

You can check the startup status by checking the logs, like this:

```shell
$ docker logs poppins
```
You can test your installation with the cli toolkit like this:

```shell
$ docker exec -ti poppins /opt/nifi/nifi-toolkit-current/bin/cli.sh nifi current-user
```

***NOTE:*** Any files modified during the session are lost when the container is destroyed. To preserve changes see next section.

### Preserving changes

To preserve files modified inside the docker container, copy them to the repo before shutting down the container:

```shell
$ docker cp `docker ps -alq`:/opt/nifi/nifi-current/conf/flow.xml.gz conf
```

Then commit as usual.

***NOTE:*** This assumes poppins was the last container to be initialized, if not, run `docker ps` to find the container id and replace it in the command.

***IMPORTANT:*** If you need persistent storage for your data, you should assign a volumen to your docker container, or configure a PVC to your deployment on kubernetes.

## Deploy

To update the image on the registry, use this command to release the image to docker hub:

```shell
$ docker push poder/poppins:0.1
```

***IMPORTANT:*** You need to run `docker login` before pushing the image to the registry.

After that just delete the pods in kubernetes so they pull the image again.
