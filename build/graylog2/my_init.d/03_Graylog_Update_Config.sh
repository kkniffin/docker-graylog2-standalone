#!/bin/bash

# If Configuration files dont exist, then copy the default package config
if [ ! -f /etc/graylog/server/server.conf ]; then
  cp /opt/config_templates/graylog/server.conf /etc/graylog/server/
fi

if [ ! -f /etc/graylog/server/log4j2.xml ]; then
  cp /opt/config_templates/graylog/log4j2.xml /etc/graylog/server/
fi

# Modify Configuration Files with Environment Variables that were passed
#if [[ ! $(grep -Pzo '####\nCUSTOM SETTINGS\n####' /etc/graylog/server/server.conf) ]]; then echo -e "\n\n#### CUSTOM SETTINGS ####\n" >> /etc/graylog/server/server.conf; fi

# Remove Existing Custom Config
sed -i '/#<-- START SETTINGS -->.*/,$ d' /etc/graylog/server/server.conf

# Start Custom Config Section
echo -e "#<-- START SETTINGS -->" >> /etc/graylog/server/server.conf

for ENVVARIABLE in ${!GRAYLOG_*}
do

	# Remove Graylog_ Prefix from Environment Variables
        CONFIGVARIABLE="$(echo ${ENVVARIABLE,,} | sed "s/graylog_//i")"
        # Get Value for Variable
        CONFIGVALUE="$(printenv $ENVVARIABLE)"

        # Check If Config Variable is in configuration and not commented out.
        if [[ $(egrep "^${CONFIGVARIABLE}" /etc/graylog/server/server.conf) ]]; then
 	       # Comment it out so it can be added to the end of the file
               sed -i "s|^${CONFIGVARIABLE}|#${CONFIGVARIABLE}|g" /etc/graylog/server/server.conf
	fi

	# Write Variable
	echo "${CONFIGVARIABLE} = ${CONFIGVALUE}" >> /etc/graylog/server/server.conf


#	if [[ $(printenv $ENVVARIABLE) ]]; then
#              # Remove Graylog_ Prefix from Environment Variables
#              CONFIGVARIABLE="$(echo ${ENVVARIABLE,,} | sed "s/graylog_//i")"
#              # Get Value for Variable
#              CONFIGVALUE="$(printenv $ENVVARIABLE)"
#
#              # Check if Valid Configuration already exists and skip if so
#              if [[ ! $(egrep "^`printf '%q' ${CONFIGVARIABLE}` = `printf '%q' ${CONFIGVALUE}`" /etc/graylog/server/server.conf) ]]; then
#
#                  # Check If Config Variable is in configuration and not commented out.
#                  if [[ $(egrep "^${CONFIGVARIABLE}" /etc/graylog/server/server.conf) ]]; then
#                      # Comment it out so it can be added to the end of the file
#                      sed -i "s|^${CONFIGVARIABLE}|#${CONFIGVARIABLE}|g" /etc/graylog/server/server.conf
#                      echo "${CONFIGVARIABLE} = ${CONFIGVALUE}" >> /etc/graylog/server/server.conf
#                  else
#                      # Wasn't uncommented in config so adding to end of configuration file
#                      echo "${CONFIGVARIABLE} = ${CONFIGVALUE}" >> /etc/graylog/server/server.conf
#                  fi
#
#              fi
#        fi

done

# End Custom Config Section
echo -e "#<-- END SETTINGS -->" >> /etc/graylog/server/server.conf
