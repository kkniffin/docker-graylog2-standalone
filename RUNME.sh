#!/bin/bash

# PLEASE NOTE: NO CHANGES NEED TO MEED TO THIS FILE IF YOU WANT TO CUSTOMIZE VARIABLES.
# PLEASE USE THE OVERRIDES.ENV FILE SO THAT YOUR CUSTOMIZATIONS WONT BE LOST ON A GIT PULL

# Load Overrides File for overwriting Environment Variables in this file
# This will allow git pulls as they will overwrite this file, but not the overrides.env
# Format is VARIABLE=DATA
if ! [ -f ./overrides.env ]; then
	touch ./overrides.env
fi
. ./overrides.env

# Set Variables
## General
export COMPOSE_PROJECT_NAME="docker-graylog2-standalone"
export COMPOSE_DOCKER_DATA="${DOCKER_DATA:-/opt/docker_data}"
export COMPOSE_DOCKER_CONFIG="${DOCKER_CONFIG:-/opt/docker_config}"
export COMPOSE_FLUENTD_SERVER="${FLUENTD_SERVER:-1.1.1.1}"

## MongoDB Docker Compose Settings
#### MongoDB Replication Set Name
export COMPOSE_MONGODB_REPLICATIONSET_NAME="${COMPOSE_MONGO_REPLICATIONSET_NAME:-GraylogSet}" # Default: GraylogSet
export COMPOSE_MONGODB_REPLICATIONSET_PRIMARY="${COMPOSE_MONGODB_REPLICATIONSET_PRIMARY:-true}"
export COMPOSE_MONGODB_REPLICATIONSET_HOSTNAME="${COMPOSE_MONGODB_REPLICATIONSET_HOSTNAME:-$(hostname -f)}" # MongoDB Replication Hostname, if not set will default to Docker Parent Hostname
export COMPOSE_MONGODB_GRAYLOGDB_PW="${COMPOSE_MONGODB_GRAYLOG_PW:-changeme}" # Username: graylogdb/changeme
export COMPOSE_MONGODB_SUPERADMIN_PW="${COMPOSE_MONGODB_SUPERADMIN_PW:-changeme}" # Username: superadmin/changeme
export COMPOSE_MONGODB_PUBLICIP="${COMPOSE_MONGODB_PUBLICIP:-$(/sbin/ifconfig eth0 | grep 'inet ' | grep -Eow '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)}"

#######################################
# Graylog Docker Compose Settings #####
#######################################

##### GRAYLOG GENERAL
# Graylog Secret used for encrypting information
export COMPOSE_GRAYLOG_PASSWORD_SECRET="${COMPOSE_GRAYLOG_PASSWORD_SECRET:-mysecret}"
# Graylog Root Password for Web interface in SHA2 format, Override and set using command: echo -n yourpassword | sha256sum
export COMPOSE_GRAYLOG_ROOT_PASSWORD_SHA2="${COMPOSE_GRAYLOG_ROOT_PASSWORD_SHA2:-5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8}"
# Graylog Root Email
export COMPOSE_GRAYLOG_ROOT_EMAIL="${COMPOSE_GRAYLOG_ROOT_EMAIL}"
# Whether this Graylog is the Master. I believe you only have one
export COMPOSE_GRAYLOG_MASTER="${COMPOSE_GRAYLOG_MASTER:-true}"
#####


##### GRAYLOG ELASTICSEARCH SETTINGS
# Name of Elasticsearch Cluster Graylog ES Client should join
export COMPOSE_GRAYLOG_ES_CLUSTERNAME="${COMPOSE_GRAYLOG_ES_CLUSTERNAME:-graylog}"
# ElasticSearch Hosts Graylog ES Client should connect to : EX: es-node-1.example.org:9300,es-node-2.example.org:9300
export COMPOSE_GRAYLOG_ES_HOSTS="${COMPOSE_GRAYLOG_ES_HOSTS:-elasticsearch:9300}" \
# Override this in overrides.env file and set to Public IP that others can connect to, if not set will default to eth0 ip of docker parent, should be http://<publicip>:9000/api
export COMPOSE_GRAYLOG_ES_MULTICAST_ENABLED="${COMPOSE_GRAYLOG_ES_MULTICAST_ENABLED:-false}"
# Should be set to Public Accessible IP
export COMPOSE_GRAYLOG_ES_PUBLISH_HOST="${COMPOSE_GRAYLOG_ES_PUBLISH_HOST:-$(/sbin/ifconfig eth0 | grep 'inet ' | grep -Eow '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)}" #Uses IP of ETH0 Docker Parent by default
export COMPOSE_GRAYLOG_ES_NETWORK_HOST="${COMPOSE_GRAYLOG_ES_NETWORK_HOST:-0.0.0.0}"
export COMPOSE_GRAYLOG_ES_SHARDS="${COMPOSE_GRAYLOG_ES_SHARDS:-4}"
export COMPOSE_GRAYLOG_ES_REPLICAS="${COMPOSE_GRAYLOG_ES_REPLICAS:-1}"
#####


##### GRAYLOG MAIL OPTIONS
# Mail Options for Sending Alerts
export COMPOSE_GRAYLOG_TRANSPORT_EMAIL_FROM_EMAIL="${COMPOSE_GRAYLOG_TRANSPORT_EMAIL_FROM_EMAIL:-mail@test.com}"
export COMPOSE_GRAYLOG_MAILHOST="${COMPOSE_GRAYLOG_MAILHOST:-mailhost.mail.com}"
export COMPOSE_GRAYLOG_MAILPORT="${COMPOSE_GRAYLOG_MAILPORT:-25}"
export COMPOSE_GRAYLOG_MAILAUTHUSERNAME="${COMPOSE_GRAYLOG_MAILAUTHUSERNAME:-username}"
export COMPOSE_GRAYLOG_MAILAUTHPASSWORD="${COMPOSE_GRAYLOG_MAILAUTHPASSWORD:-password}"
# URL that will be embedded in alerts for going to GrayLog Server
export COMPOSE_GRAYLOG_URL="${COMPOSE_GRAYLOG_URL:-http://$(/sbin/ifconfig eth0 | grep 'inet ' | grep -Eow '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1):9000}"
#####

##### GRAYLOG MONGODB OPTIONS
# MongoDB Server for Graylog to use, if using multiple just override the COMPOSE_GRAYLOG_MONGODB_URI and set appropriately
export COMPOSE_GRAYLOG_MONGODB_SERVER="${COMPOSE_GRAYLOG_MONGODB_SERVER:-mongodb}"
# Form Multi-Node this becomes: mongodb://USERNAME:PASSWORD@mongodb-node01:27017,mongodb-node02:27017,mongodb-node03:27017/graylog?replicaSet=rs01
export COMPOSE_GRAYLOG_MONGODB_URI="${COMPOSE_GRAYLOG_MONGODB_URI:-mongodb://graylogdb:${COMPOSE_MONGODB_GRAYLOGDB_PW}@${COMPOSE_GRAYLOG_MONGODB_SERVER}:27017/graylog?replicaSet=${COMPOSE_MONGODB_REPLICATIONSET_NAME}}"
#####

##### GRAYLOG WEB OPTIONS
# Set REST Transport URI to External IP so that all Cluster Nodes can connect with it
export COMPOSE_GRAYLOG_REST_LISTEN_URI="${COMPOSE_GRAYLOG_REST_LISTEN_URI:-http://0.0.0.0:12900}" # http://0.0.0.0:9000/api
# Should be Public IP
export COMPOSE_GRAYLOG_REST_TRANSPORT_URI="${COMPOSE_GRAYLOG_REST_TRANSPORT_URI:-http://$(/sbin/ifconfig eth0 | grep 'inet ' | grep -Eow '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1):12900}" # http://<publicip>:9000/api
export COMPOSE_GRAYLOG_WEB_LISTEN_URI="${COMPOSE_GRAYLOG_WEB_LISTEN_URI:-http://0.0.0.0:9000}" # http://0.0.0.0:9000
export COMPOSE_GRAYLOG_WEB_ENDPOINT_URI="${COMPOSE_GRAYLOG_WEB_ENDPOINT_URI:-http://$(/sbin/ifconfig eth0 | grep 'inet ' | grep -Eow '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1):12900}" # http://<publicip>:9000/api
export COMPOSE_GRAYLOG_WEB_ENABLE="${COMPOSE_GRAYLOG_WEB_ENABLE:-true}"
export COMPOSE_GRAYLOG_WEB_ENABLE_TLS="${COMPOSE_GRAYLOG_WEB_ENABLE_TLS:-false}"
export COMPOSE_GRAYLOG_WEB_TLS_CERT_FILE="${COMPOSE_GRAYLOG_WEB_TLS_CERT_FILE:-/path/to/graylog-web.crt}"
export COMPOSE_GRAYLOG_WEB_TLS_KEY_FILE="${COMPOSE_GRAYLOG_WEB_TLS_KEY_FILE:-/path/to/graylog-web.key}"
export COMPOSE_GRAYLOG_WEB_TLS_KEY_PASSWORD="${COMPOSE_GRAYLOG_WEB_TLS_KEY_PASSWORD:-secret}"

#####



# Run Standard Docker-Compose with Arguments
docker-compose "$@"
