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

# Copy flow_storage dir
#COPY --chown=nifi:nifi flow_storage $FLOW_STORAGE_DIR

COPY  certs/nifi.crt ${NIFI_REGISTRY_HOME}
COPY  certs/nifi-trust.jks ${NIFI_REGISTRY_HOME}
COPY  certs/ca.crt ${NIFI_REGISTRY_HOME}
COPY  certs/poppins-registry.beta.quienesquien.wiki.crt ${NIFI_REGISTRY_HOME}

# Copy cert to keytool
RUN   keytool -importcert -v -trustcacerts -alias root-ca-cert -file ${NIFI_REGISTRY_HOME}/ca.crt -keystore ${NIFI_REGISTRY_HOME}/nifi-trust.jks -storepass myadminpw -noprompt
RUN   keytool -importcert -alias admin-nifi-cert -file ${NIFI_HOME}/certs/nifi.crt -keystore ${NIFI_HOME}/certs/nifi-trust.jks -storepass myadminpw -noprompt
RUN   keytool -importcert -alias registry-cert -file ${NIFI_REGISTRY_HOME}/poppins-registry.beta.quienesquien.wiki.crt -keystore ${NIFI_REGISTRY_HOME}/nifi-trust.jks -storepass myadminpw -noprompt

USER nifi
WORKDIR ${NIFI_REGISTRY_HOME}
