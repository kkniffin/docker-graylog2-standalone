#!/bin/bash

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

## Graylog Docker Compose Settings
export COMPOSE_GRAYLOG_PASSWORD_SECRET="${COMPOSE_GRAYLOG_PASSWORD_SECRET:-mysecret}"
export COMPOSE_GRAYLOG_ROOT_PASSWORD_SHA2="${COMPOSE_GRAYLOG_ROOT_PASSWORD_SHA2:-5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8}"
export COMPOSE_GRAYLOG_ROOT_EMAIL="${COMPOSE_GRAYLOG_ROOT_EMAIL}"
export COMPOSE_GRAYLOG_ES_CLUSTERNAME="${COMPOSE_GRAYLOG_ES_CLUSTERNAME:-graylog}"
export COMPOSE_GRAYLOG_ES_HOSTS="${COMPOSE_GRAYLOG_ES_HOSTS:-elasticsearch:9300}" # EX: es-node-1.example.org:9300,es-node-2.example.org:9300
export COMPOSE_GRAYLOG_WEB_ENDPOINT_URI="${COMPOSE_GRAYLOG_WEB_ENDPOINT_URI:-http://1.1.1.1:9000/api}"
export COMPOSE_GRAYLOG_TRANSPORT_EMAIL_FROM_EMAIL="${COMPOSE_GRAYLOG_TRANSPORT_EMAIL_FROM_EMAIL:-mail@test.com}"
export COMPOSE_GRAYLOG_MAILHOST="${COMPOSE_GRAYLOG_MAILHOST:-mailhost.mail.com}"
export COMPOSE_GRAYLOG_MAILPORT="${COMPOSE_GRAYLOG_MAILPORT:-25}"
export COMPOSE_GRAYLOG_MAILAUTHUSERNAME="${COMPOSE_GRAYLOG_MAILAUTHUSERNAME:-username}"
export COMPOSE_GRAYLOG_MAILAUTHPASSWORD="${COMPOSE_GRAYLOG_MAILAUTHPASSWORD:-password}"
export COMPOSE_GRAYLOG_URL="${COMPOSE_GRAYLOG_URL:-http://1.1.1.1}"
export COMPOSE_GRAYLOG_MONGODB_SERVER="${COMPOSE_GRAYLOG_MONGODB_SERVER:-mongodb}"
# Form Multi-Node this becomes: mongodb://USERNAME:PASSWORD@mongodb-node01:27017,mongodb-node02:27017,mongodb-node03:27017/graylog?replicaSet=rs01
export COMPOSE_GRAYLOG_MONGODB_URI="${COMPOSE_GRAYLOG_MONGODB_URI:-mongodb://graylogdb:${COMPOSE_MONGODB_GRAYLOGDB_PW}@${COMPOSE_GRAYLOG_MONGODB_SERVER}:27017/graylog?replicaSet=${COMPOSE_MONGODB_REPLICATIONSET_NAME}}"
export COMPOSE_GRAYLOG_ES_MULTICAST_ENABLED="${COMPOSE_GRAYLOG_ES_MULTICAST_ENABLED:-false}"
export COMPOSE_GRAYLOG_ES_PUBLISH_HOST="${COMPOSE_GRAYLOG_ES_PUBLISH_HOST:-0.0.0.0}"
export COMPOSE_GRAYLOG_ES_NETWORK_HOST="${COMPOSE_GRAYLOG_ES_NETWORK_HOST:-0.0.0.0}"
export COMPOSE_GRAYLOG_MASTER="${COMPOSE_GRAYLOG_MASTER:-true}"
# Set REST Transport URI to External IP so that all Cluster Nodes can connect with it
export COMPOSE_GRAYLOG_REST_TRANSPORT_URI="${COMPOSE_GRAYLOG_REST_TRANSPORT_URI:-http://$(/sbin/ifconfig eth0 | grep 'inet ' | grep -Eow '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1):12900}"

# Run Standard Docker-Compose with Arguments
docker-compose "$@"
