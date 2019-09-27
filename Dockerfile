# Poppins works on Apache NiFi.
# Dockerfile inheritance: nifi, openjdk:8-jre, debian:stretch-slim
FROM        apache/nifi:1.9.0

# NOTE: This docker image inherits:
# EXPOSE    8080 8443 10000 8000
# WORKDIR   ${NIFI_HOME}
# ENTRYPOINT ["../scripts/start.sh"]

# We're creating files at the root, so we need to be root.
USER       root
ENV        POPPINS_FILES_DIR=/poppins_files
ENV        POPPINS_SCRIPTS_DIR=$NIFI_HOME/scripts

# Install nodejs and npm for scripts
RUN        curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN        apt-get update && apt-get install -y nodejs git npm

# Create volume dirs for cluster
VOLUME     ${POPPINS_FILES_DIR} \
           ${POPPINS_SCRIPTS_DIR} \
           ${NIFI_HOME}/conf/ \
           ${NIFI_HOME}/certs/ \
           $NIFI_HOME/.git/ \
           ${NIFI_HOME}

# Copy files from our repo
#RUN        mkdir $POPPINS_FILES_DIR && mkdir $POPPINS_SCRIPTS_DIR && mkdir $NIFI_HOME/certs/ && mkdir ~/.ssh/
RUN         mkdir ~/.ssh/
COPY       poppins_files $POPPINS_FILES_DIR/
COPY       certs/* $NIFI_HOME/certs/
COPY       scripts $POPPINS_SCRIPTS_DIR/
COPY       --chown=nifi:nifi conf/bootstrap.conf $NIFI_HOME/conf/
#COPY       --chown=nifi:nifi conf/authorizers.xml $NIFI_HOME/conf/
#COPY       --chown=nifi:nifi conf/nifi.properties $NIFI_HOME/conf/
COPY       --chown=nifi:nifi conf/flow.xml.gz $NIFI_HOME/conf/
COPY       --chown=nifi:nifi .git $NIFI_HOME/.git/

# Install remote scripts
RUN        ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN        cd $POPPINS_SCRIPTS_DIR/cnet2ocds && npm install  --production=true --modules_folder=$POPPINS_SCRIPTS_DIR/node_modules && cd ../stream2db && npm install  --production=true --modules_folder=$POPPINS_SCRIPTS_DIR/node_modules && cd ../stream2db && npm install --production=true --modules_folder=$POPPINS_SCRIPTS_DIR/node_modules && cd ../cnet32ocds && npm install --production=true --modules_folder=$POPPINS_SCRIPTS_DIR/node_modules && cd ../pot2ocds && npm install --production=true --modules_folder=$POPPINS_SCRIPTS_DIR/node_modules && cd ../cargografias-transformer && npm install --production=true --modules_folder=$POPPINS_SCRIPTS_DIR/node_modules

# Change back the owner of the created files and folders
RUN        chown nifi:nifi $NIFI_HOME/conf/* $NIFI_HOME/certs $NIFI_HOME/certs/* $POPPINS_FILES_DIR $POPPINS_FILES_DIR/* $POPPINS_SCRIPTS_DIR $POPPINS_SCRIPTS_DIR/*

# copy cert to keytool
RUN      keytool -import -trustcacerts -file ${NIFI_HOME}/certs/nifi-cert.pem -alias POPPINS -keystore ${JAVA_HOME}/lib/security/cacerts -noprompt -storepass changeit
