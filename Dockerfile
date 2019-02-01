FROM apache/nifi:latest
USER root
RUN mkdir /opt/nifi/nifi-current/certs/
RUN mkdir /poppins_files/
COPY certs/* /opt/nifi/nifi-current/certs/
COPY conf/* /opt/nifi/nifi-current/conf/
COPY poppins_files /poppins_files/
RUN chown nifi:nifi /opt/nifi/nifi-current/conf/* /opt/nifi/nifi-current/certs /opt/nifi/nifi-current/certs/* /poppins_files /poppins_files/*
