FROM       xemuliam/nifi-base:1.9.2
MAINTAINER kronops <kronops@kronops.com.mx>
ENV        BANNER_TEXT="POPPINS" \
           S2S_PORT="" \
           POPPINS_FILES_DIR=poppins_files \
           POPPINS_SCRIPTS_DIR=$NIFI_HOME/scripts \
           POPPINS_CERTS=$NIFI_HOME/certs/ \
           POPPINS_SSH=/root/.ssh/ \
           POPPINS_CONF=$NIFI_HOME/conf/ \
           POPPINS_GIT=$NIFI_HOME/.git/
COPY       start_nifi.sh /${NIFI_HOME}/
RUN        apk add --update nodejs npm
RUN        apk add --update npm
VOLUME     ${POPPINS_SCRIPTS_DIR} \
	         ${POPPINS_FILES_DIR} \
      	   ${POPPINS_CERTS} \
           ${POPPINS_SSH} \
           ${POPPINS_CONF} \
           ${POPPINS_GIT} \
           ${NIFI_HOME}/logs \
           ${NIFI_HOME}
COPY       poppins_files $POPPINS_FILES_DIR/
COPY       certs/* $POPPINS_CERTS
COPY       scripts $POPPINS_SCRIPTS_DIR/
COPY       conf/bootstrap.conf $POPPINS_CONF
COPY       conf/authorizers.xml $POPPINS_CONF
COPY       conf/nifi.properties $POPPINS_CONF
COPY       conf/flow.xml.gz $POPPINS_CONF
COPY       .git $POPPINS_GIT
RUN        apk add --no-cache openssh-client && ssh-keyscan -t rsa github.com >> $POPPINS_SSH/known_hosts
RUN        cd $POPPINS_SCRIPTS_DIR/cnet2ocds && npm install  --production=true --modules_folder=$POPPINS_SCRIPTS_DIR/node_modules && cd ../stream2db && npm install  --production=true --modules_folder=$POPPINS_SCRIPTS_DIR/node_modules && cd ../stream2db && npm install --production=true --modules_folder=$POPPINS_SCRIPTS_DIR/node_modules && cd ../cnet32ocds && npm install --production=true --modules_folder=$POPPINS_SCRIPTS_DIR/node_modules && cd ../pot2ocds && npm install --production=true \
--modules_folder=$POPPINS_SCRIPTS_DIR/node_modules && cd ../cargografias-transformer && npm install --production=true --modules_folder=$POPPINS_SCRIPTS_DIR/node_modules
