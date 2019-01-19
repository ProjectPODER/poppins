FROM apache/nifi:latest
RUN mkdir /opt/nifi/nifi-current/certs/
COPY certs/* /opt/nifi/nifi-current/certs/
COPY conf/* /opt/nifi/nifi-current/conf/
USER root
RUN chown nifi:nifi /opt/nifi/nifi-current/conf/* /opt/nifi/nifi-current/certs /opt/nifi/nifi-current/certs/*
