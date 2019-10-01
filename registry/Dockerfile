# Nifi Registry for Poppins works on Apache NiFi.
# Dockerfile inheritance: nifi, openjdk:8-jre, debian:stretch-slim
FROM apache/nifi-registry:0.5.0

# NOTE: This docker image inherits:
# EXPOSE 18080

# We're creating files at the root, so we need to be root.
USER root
ENV FLOW_STORAGE_DIR=/flow_storage
ENV NIFI_REGISTRY_HOME=/opt/nifi-registry/nifi-registry-0.5.0
ENV NIFI_REGISTRY_BASE_DIR=/opt/nifi-registry
# nifi certs vars
ENV NIFI_CERTS_DIR=${NIFI_REGISTRY_HOME}/certs
ENV ROOT_CA=${NIFI_CERTS_DIR}/rootCA.crt
ENV NIFI_CRT=${NIFI_CERTS_DIR}/nifi.crt
ENV NIFI_KEYSTORE=${NIFI_CERTS_DIR}/nifi-trust.jks
ENV POPPINS_CRT=${NIFI_CERTS_DIR}/poppins-registry.beta.quienesquien.wiki.crt
# copy nifi certs
COPY --chown=nifi:nifi nifi-certs/* ${NIFI_CERTS_DIR}/
# create truststore and import cert for poppins-registry
RUN keytool -importcert -v -trustcacerts -alias root-ca -file $ROOT_CA -keystore $NIFI_KEYSTORE -storepass myadminpw -noprompt
RUN keytool -importcert -alias cnifi-registry -file $POPPINS_CRT -keystore $NIFI_KEYSTORE -storepass myadminpw -noprompt
RUN keytool -importcert -alias cnifi-admin -file $NIFI_CRT -keystore $NIFI_KEYSTORE -storepass myadminpw -noprompt

USER nifi
WORKDIR ${NIFI_REGISTRY_HOME}
