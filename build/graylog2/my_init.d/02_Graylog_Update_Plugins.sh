#!/bin/bash
# Script to download plugins and content packs
# Plugins go into ${GRAYLOG_PLUGIN_DIR}
# Content Packs go into ${GRAYLOG_CONTENT_PACKS_DIR}

#### PLUGINS #######
####################
curl -s -n https://api.github.com/repos/Graylog2/graylog-plugin-netflow/releases/latest | grep browser_download_url | grep .jar | cut -d'"' -f4 | wget -i - -O ${GRAYLOG_PLUGIN_DIR}/graylog-netflow-plugin.jar
curl -s -n https://api.github.com/repos/Graylog2/graylog-plugin-dnsresolver/releases/latest | grep browser_download_url | grep .jar | cut -d'"' -f4 | wget -i - -O ${GRAYLOG_PLUGIN_DIR}/graylog-dns-plugin.jar
# Disabled (Causes Errors)
#curl -s -n https://api.github.com/repos/cvtienhoven/graylog-plugin-aggregates/releases/latest | grep browser_download_url | grep .jar | cut -d'"' -f4 | wget -i - -O ${GRAYLOG_PLUGIN_DIR}/graylog-aggregates-plugin.jar


#### CONTENT PACKS ######
#########################

# https://github.com/reighnman/Graylog_Content_Pack_Active_Directory_Auditing
cp /usr/share/graylog-server/contentpacks/grok-patterns.json ${GRAYLOG_CONTENT_PACKS_DIR}
wget https://raw.githubusercontent.com/reighnman/Graylog_Content_Pack_Active_Directory_Auditing/master/content_pack.json -O ${GRAYLOG_CONTENT_PACKS_DIR}/reighman_adauditing.json
