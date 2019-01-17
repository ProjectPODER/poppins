FROM apache/nifi:latest
ADD certs/* /opt/nifi/nifi-current/
ADD conf/* /opt/nifi/nifi-current/conf/
USER root
RUN chown -R nifi:nifi /opt/nifi/nifi-current/* /opt/nifi/nifi-current/conf/*
