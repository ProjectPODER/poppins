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

USER nifi
WORKDIR ${NIFI_REGISTRY_HOME}
