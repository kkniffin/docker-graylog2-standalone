#!/bin/bash

# Update System so that the latest GrayLog is Installed
apt-get -y update
# Tell it to keep old configuration file
apt-get -o Dpkg::Options::="--force-confold" -y upgrade
