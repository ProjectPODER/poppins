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
# Copy cert to keytool
COPY  nifi-cert.pem ${NIFI_REGISTRY_HOME}
RUN   keytool -import -trustcacerts -file ${NIFI_REGISTRY_HOME}/nifi-cert.pem -alias REGISTRY -keystore ${JAVA_HOME}/jre/lib/security/cacerts -noprompt -storepass changeit

USER nifi
WORKDIR ${NIFI_REGISTRY_HOME}
