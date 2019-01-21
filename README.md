Poppins is an Apache NiFi based data pipeline for the QuienEsQuien.wiki project

# Run
To update the image with the latest changes from the repo and run poppins:
```
docker build . -t poder/poppins:0.1 && docker run  -p 8080:8080 poder/poppins:0.1`
```

Note: Any files modified during the session are lost when the container is destroyed. To preserve changes see next section.

# Preserving changes

To preserve files modified inside the docker container, copy them to the repo before shutting down the container:
```
docker cp `docker ps -alq`:/opt/nifi/nifi-current/conf/flow.xml.gz conf
```
Then commit as usual.

Note: This assumes poppins was the last container to be initialized, if not, run `docker ps` to find the container id and replace it in the command.

# Deploy
To update the image and push it to docker hub:
```
docker build . -t poder/poppins:0.1 && docker push poder/poppins:0.1
```

After that just delete the pods in kubernetes so they pull the image again.
