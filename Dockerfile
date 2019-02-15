# Poppins works on Apache NiFi.
# Dockerfile inheritance: nifi, openjdk:8-jre, debian:stretch-slim
FROM apache/nifi:latest

# We're creating files at the root, so we need to be root.
USER root
ENV POPPINS_FILES=/poppins_files

# Install nodejs for scripts
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs git

# Copy files from our repo
RUN mkdir $POPPINS_FILES
COPY poppins_files $POPPINS_FILES/

RUN mkdir $NIFI_HOME/certs/
COPY certs/* $NIFI_HOME/certs/
COPY conf/* $NIFI_HOME/conf/

# Install remote scripts
RUN mkdir ~/.ssh/
RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN cd $POPPINS_FILES && npm install git+https://github.com/ProjectPODER/cnet2ocds.git

# Change back the owner of the created files and folders
RUN chown nifi:nifi $NIFI_HOME/conf/* $NIFI_HOME/certs $NIFI_HOME/certs/* $POPPINS_FILES $POPPINS_FILES/*
