#!/bin/bash

# If MongoDB is Primary then setup User's and Database
if [[ ${MONGODB_REPLICATIONSET_PRIMARY,,} = "true" ]] && [ ! -f /data/db/db_is_setup ] && [ ${MONGODB_REPLICATIONSET_HOSTNAME+"false"} ]; then

# Wait for MongoDB to come up.
echo "###################################################################################"
echo "######## MONGO SETUP - SLEEPING FOR 10 SECS TO WAIT FOR MONGODB TO COME UP ########"
echo "###################################################################################"
sleep 10

# Initiate Replica Node as Primary
#echo "###################################################################################"
#echo "####### MONGO SETUP - NEEDS TO BE SETUP AS PRIMARY ################################"
#echo "###################################################################################"
#mongo --eval "var res = rs.initiate(); printjson(res)"

# Wait for Replication to Complete
#echo "###################################################################################"
#echo "####### MONGO SETUP - SLEEPNG FOR 5 SECS FOR REPLICATION TO FINISH ################"
#echo "###################################################################################"
#sleep 5

# Post Hostname to Local Hosts File, otherwise wont come up.
echo "127.0.0.1 ${MONGODB_REPLICATIONSET_HOSTNAME}" >> /etc/hosts

# Export Config to js file for reading into Mongo
cat <<EOT> /tmp/setup_mongodb.js

var replicaconfig = { _id: "${MONGODB_REPLICATIONSET_NAME}",
    members: [
        { _id: 0, host: "${MONGODB_REPLICATIONSET_HOSTNAME}"}
    ]
};
print('################ MONGODB - Initiating Replica Configuration ################');
rs.initiate(replicaconfig);

print('################ MONGODB - Checking Replica Status ################');
while ( rs.status().startupStatus || (rs.status().hasOwnProperty("myState") && rs.status().myState != 1)) {
	print('################ MONGODB - Replica Not Ready, Status is: ################');
	printjson( rs.status() );
	sleep(1000);
};

print('################ MONGODB - Replica Ready, Status is: ################');
printjson( rs.status() );

admin = db.getSiblingDB("admin")

print('################ MONGODB - Creating SuperAdmin ################');
db.getSiblingDB("admin").createUser(
  {
    "user" : "superadmin",
    "pwd" : "${MONGODB_SUPERADMIN_PW}",
    roles: [ { "role" : "root", "db" : "admin" } ]
  }
)

print('################ MONGODB - Authenticating as SuperAdmin ################');
db.getSiblingDB("admin").auth("superadmin", "${MONGODB_SUPERADMIN_PW}" )

print('################ MONGODB - Creating Graylog DB ################');
use graylog

print('################ MONGODB - Creating Graylog User ################');
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
touch /data/db/db_is_setup

elif [[ ! ${MONGODB_REPLICATIONSET_PRIMARY,,} = "true" ]]; then

echo "###################################################################################"
echo "####### MONGO SETUP - NOT SET AS PRIMARY ##########################################"
echo "###################################################################################"

elif [ -f /data/db/db_is_setup ]; then

echo "###################################################################################"
echo "####### MONGO SETUP - DATABASE ALREADY SETUP ######################################"
echo "###################################################################################"

fi

#	admin.createUser(
#          {
#            user: "admin",
#            pwd: "changeme",
#            roles: [ { role: "userAdminAnyDatabase", "db" : "admin" } ]
#          }
#       )
