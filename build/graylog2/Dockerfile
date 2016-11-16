FROM phusion/baseimage:latest

ENV DEBIAN_FRONTEND noninteractive
ENV GRAYLOG_PASSWORD_SECRET mysecret
ENV GRAYLOG_ROOT_PASSWORD_SHA2 5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8
ENV GRAYLOG_WEB_LISTEN_URI http://0.0.0.0:9000
ENV GRAYLOG_REST_LISTEN_URI http://0.0.0.0:9000/api
ENV GRAYLOG_ROOT_EMAIL admin@email.com
ENV GRAYLOG_ROOT_TIMEZONE UTC
ENV GRAYLOG_ELASTICSEARCH_MAX_TIME_PER_INDEX 1d
ENV GRAYLOG_ELASTICSEARCH_MAX_NUMBER_OF_INDICES 30
ENV GRAYLOG_ELASTICSEARCH_INDEX_PREFIX graylog
ENV GRAYLOG_ELASTICSEARCH_CLUSTER_NAME graylog
ENV GRAYLOG_ELASTICSEARCH_DISCOVERY_ZEN_PING_UNICAST_HOSTS elasticsearch:9300
ENV GRAYLOG_ELASTICSEARCH_DISCOVERY_ZEN_PING_MULTICAST_ENABLED false
ENV GRAYLOG_ELASTICSEARCH_NETWORK_HOST 0.0.0.0
ENV GRAYLOG_TRANSPORT_EMAIL_ENABLED true
ENV GRAYLOG_TRANSPORT_EMAIL_HOSTNAME mailhost.mail.com
ENV GRAYLOG_TRANSPORT_EMAIL_PORT 25
ENV GRAYLOG_TRANSPORT_EMAIL_USE_AUTH "false"
ENV GRAYLOG_TRANSPORT_EMAIL_USE_TLS "false"
ENV GRAYLOG_TRANSPORT_EMAIL_USE_SSL "false"
ENV GRAYLOG_TRANPSORT_EMAIL_AUTH_USERNAME mailusername
ENV GRAYLOG_TRANSPORT_EMAIL_AUTH_PASSWORD mailpassword
ENV GRAYLOG_TRANSPORT_EMAIL_SUBJECT_PREFIX "[graylog]"
ENV GRAYLOG_TRANSPORT_EMAIL_FROM_EMAIL graylog@test.com
ENV GRAYLOG_TRANSPORT_EMAIL_WEB_INTERFACE_URL http://127.0.0.1:9000
ENV GRAYLOG_TRANSPORT_EMAIL_FROM_EMAIL "graylog@mail.com"
ENV GRAYLOG_MONGODB_URI mongodb://127.0.0.1/graylog
ENV GRAYLOG_PLUGIN_DIR /graylog_plugins
ENV GRAYLOG_CONTENT_PACKS_DIR /graylog_contentpacks
ENV GRAYLOG_ELASTICSEARCH_NODE_MASTER "false"
ENV GRAYLOG_ELASTICSEARCH_NODE_DATA "false"
ENV GRAYLOG_WEB_ENDPOINT_URI "http://1.1.1.1:9000/api"
ENV GRAYLOG_ELASTICSEARCH_NETWORK_PUBLISH_HOST 0.0.0.0
ENV GRAYLOG_ELASTICSEARCH_NETWORK_HOST 0.0.0.0
ENV GRAYLOG_WEB_ENABLE: true
ENV GRAYLOG_WEB_ENABLE_TLS: false
ENV GRAYLOG_WEB_TLS_CERT_FILE: /path/to/graylog-web.crt
ENV GRAYLOG_WEB_TLS_KEY_FILE: /path/to/graylog-web.key
ENV GRAYLOG_WEB_TLS_KEY_PASSWORD: secret
ENV GRAYLOG_ELASTICSEARCH_SHARDS: 4
ENV GRAYLOG_ELASTICSEARCH_REPLICAS: 0






RUN apt-get -qq update \
    && apt-get -y upgrade -o Dpkg::Options::="--force-confold" \
    && apt-get -y dist-upgrade \
    && apt-get install -y curl \
    ntp \
    ntpdate \
    tzdata \
    jq \
    wget \
    apt-transport-https \
    openjdk-8-jre-headless \
    uuid-runtime \
    pwgen \
    net-tools

# Install GrayLog
WORKDIR /usr/local/src
RUN wget https://packages.graylog2.org/repo/packages/graylog-2.1-repository_latest.deb \
    && dpkg -i graylog*.deb \
    && apt-get update \
    && apt-get install graylog-server

# Copy Default Config to new location
RUN mkdir -p /opt/config_templates/graylog \
    && cp /etc/graylog/server/log4j2.xml  /opt/config_templates/graylog/ \
    && cp /etc/graylog/server/server.conf  /opt/config_templates/graylog/

RUN mkdir -p /etc/my_init.d
RUN mkdir -p /graylog_plugins
RUN mkdir -p /graylog_contentpacks
COPY ./my_init.d/ /etc/my_init.d/
COPY ./service/ /etc/service/

EXPOSE 9200
EXPOSE 9300
EXPOSE 9350

VOLUME ["/etc/graylog/server/","/graylog_plugins","/graylog_contentpacks"]
