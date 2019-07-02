# Poppins works on Apache NiFi.
# Dockerfile inheritance: nifi, openjdk:8-jre, debian:stretch-slim
FROM apache/nifi:1.8.0

# NOTE: This docker image inherits:
# EXPOSE 8080 8443 10000 8000
# WORKDIR ${NIFI_HOME}
# ENTRYPOINT ["../scripts/start.sh"]

# We're creating files at the root, so we need to be root.
USER root
ENV POPPINS_FILES_DIR=/poppins_files
ENV POPPINS_SCRIPTS_DIR=/poppins_scripts

# Install nodejs for scripts
RUN apt-get update
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs git

# Copy files from our repo
RUN mkdir $POPPINS_FILES_DIR
COPY poppins_files $POPPINS_FILES_DIR/
RUN mkdir $POPPINS_SCRIPTS_DIR

RUN mkdir $NIFI_HOME/certs/
COPY certs/* $NIFI_HOME/certs/
# Disabled because cause startup to fail.
#COPY conf/* $NIFI_HOME/conf/
COPY --chown=nifi:nifi conf/bootstrap.conf /opt/nifi/nifi-current/conf/
COPY --chown=nifi:nifi conf/authorizers.xml /opt/nifi/nifi-current/conf/
COPY --chown=nifi:nifi conf/nifi.properties /opt/nifi/nifi-current/conf/
COPY --chown=nifi:nifi conf/flow.xml.gz /opt/nifi/nifi-current/conf/

# Install remote scripts
RUN mkdir ~/.ssh/
RUN ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
RUN cd $POPPINS_SCRIPTS_DIR && git clone http://gitlab.rindecuentas.org/equipo-qqw/cnet2ocds.git && cd cnet2ocds && npm install
RUN cd $POPPINS_SCRIPTS_DIR && git clone http://gitlab.rindecuentas.org/equipo-qqw/stream2db.git && cd stream2db && npm install
RUN cd $POPPINS_SCRIPTS_DIR && git clone http://gitlab.rindecuentas.org/equipo-qqw/cnet32ocds.git && cd cnet32ocds && npm install
RUN cd $POPPINS_SCRIPTS_DIR && git clone http://gitlab.rindecuentas.org/equipo-qqw/pot2ocds.git && cd pot2ocds && npm install
RUN cd $POPPINS_SCRIPTS_DIR && git clone http://gitlab.rindecuentas.org/equipo-qqw/cargografias-transformer.git && cd cargografias-transformer && npm install

# Change back the owner of the created files and folders
RUN chown nifi:nifi $NIFI_HOME/conf/* $NIFI_HOME/certs $NIFI_HOME/certs/* $POPPINS_FILES_DIR $POPPINS_FILES_DIR/* $POPPINS_SCRIPTS_DIR $POPPINS_SCRIPTS_DIR/*
