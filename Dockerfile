# Poppins works on Apache NiFi.
# Dockerfile inheritance: nifi, openjdk:8-jre, debian:stretch-slim
FROM        apache/nifi:1.9.2

# NOTE: This docker image inherits:
# EXPOSE    8080 8443 10000 8000
# WORKDIR   ${NIFI_HOME}
# ENTRYPOINT ["../scripts/start.sh"]

# We're creating files at the root, so we need to be root.
USER       root
ENV        NIFI_HOME=/opt/nifi/nifi-current
ENV        POPPINS_FILES_DIR=/poppins_files
ENV        POPPINS_SCRIPTS_DIR=$NIFI_HOME/scripts
ENV        NIFI_CERTS_DIR=${NIFI_HOME}/certs/
# Install nodejs and npm for scripts
RUN        curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN        apt-get install -y nodejs git
# Create volume dirs for cluster
VOLUME     ${NIFI_HOME}/conf/ \
           ${NIFI_HOME}/certs/ \
           ${NIFI_HOME}/.git/
# Copy files from our repo
RUN         mkdir ~/.ssh/
# COPY       poppins_files $POPPINS_FILES_DIR/
COPY       certs/* ${NIFI_CERTS_DIR}/
COPY       scripts ${POPPINS_SCRIPTS_DIR}/
COPY       .gitmodules .
COPY       --chown=nifi:nifi conf/bootstrap.conf $NIFI_HOME/conf/
COPY       --chown=nifi:nifi conf/flow.xml.gz $NIFI_HOME/conf/
COPY       --chown=nifi:nifi .git $NIFI_HOME/.git/
# Install remote scripts
RUN        ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN        git submodule foreach --recursive git checkout master
RUN        git submodule foreach --recursive git pull --ff-only origin master
RUN        git submodule foreach npm ci --production=true
# Change back the owner of the created files and folders
RUN        chown nifi:nifi $NIFI_HOME/conf/* $NIFI_HOME/certs $NIFI_HOME/certs/* $POPPINS_SCRIPTS_DIR $POPPINS_SCRIPTS_DIR/*
