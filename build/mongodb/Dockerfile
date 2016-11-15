FROM mongo:3

ENV DEBIAN_FRONTEND noninteractive
ENV MONGODB_REPLICATIONSET_NAME GraylogSet
ENV MONGODB_REPLICATIONSET_PRIMARY true
ENV MONGODB_GRAYLOGDB_PW changeme
ENV MONGODB_SUPERADMIN_PW changeme
ENV MONGODB_REPLICATIONSET_HOSTNAME changeme

RUN apt-get -qq update \
    && apt-get -y upgrade -o Dpkg::Options::="--force-confold" \
    && apt-get -y dist-upgrade \
    && apt-get -y install openssl

# Create Directories
RUN mkdir -p /config
RUN mkdir -p /scripts

# Copy Scripts
COPY  ./files/scripts/* /scripts/

# Change Permissions
RUN chmod +x /scripts/*

# Create Defautl Keyfile that is random
RUN sed -i "\$i if [ ! -e "/config/keyfile.key" ]; then openssl rand -base64 741 > /config/keyfile.key; fi" /etc/rc.local
RUN sed -i "\$i chmod 600 /config/keyfile.key" /etc/rc.local
RUN sed -i "\$i /scripts/setup_mongodb.sh &" /etc/rc.local
RUN sed -i "\$i mongod --replSet ${MONGODB_REPLICATIONSET_NAME} --keyFile /config/keyfile.key" /etc/rc.local

# Set Volumes for Mounting
VOLUME ["/config"]

CMD ["sh", "/etc/rc.local"]
