#!/bin/bash

# If MongoDB is Primary then setup User's and Database
if [[ ${MONGODB_REPLICATIONSET_PRIMARY,,} = "true" ]] && [ ! -f /scripts/db_is_setup ]; then

# Wait for MongoDB to come up.
echo "###################################################################################"
echo "######## MONGO SETUP - SLEEPING FOR 10 SECS TO WAIT FOR MONGODB TO COME UP ########"
echo "###################################################################################"
sleep 10

# Initiate Replica Node as Primary
echo "###################################################################################"
echo "####### MONGO SETUP - NEEDS TO BE SETUP AS PRIMARY ################################"
echo "###################################################################################"
mongo --eval "var res = rs.initiate(); printjson(res)"

# Wait for Replication to Complete
echo "###################################################################################"
echo "####### MONGO SETUP - SLEEPNG FOR 5 SECS FOR REPLICATION TO FINISH ################"
echo "###################################################################################"
sleep 5

# Export Config to js file for reading into Mongo
cat <<EOT> /tmp/setup_mongodb.js
	admin = db.getSiblingDB("admin")

	db.getSiblingDB("admin").createUser(
          {
            "user" : "superadmin",
            "pwd" : "${MONGODB_SUPERADMIN_PW}",
            roles: [ { "role" : "root", "db" : "admin" } ]
          }
       )

       db.getSiblingDB("admin").auth("superadmin", "${MONGODB_SUPERADMIN_PW}" )

       use graylog
       db.createUser(
         {
           user: "graylogdb",
           pwd:"${MONGODB_GRAYLOGDB_PW}",
	   roles: [
                    { role: "readWrite", db:"graylog" },
                    { role: "dbAdmin", db:"graylog" }
                  ]
         }
       )
EOT

echo "###################################################################################"
echo "####### MONGO SETUP - CREATING USERS ##############################################"
echo "###################################################################################"
mongo < /tmp/setup_mongodb.js
rm -rf /tmp/setup_mongodb.js
touch /scripts/db_is_setup

fi

#	admin.createUser(
#          {
#            user: "admin",
#            pwd: "changeme",
#            roles: [ { role: "userAdminAnyDatabase", "db" : "admin" } ]
#          }
#       )

