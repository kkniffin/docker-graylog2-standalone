# docker-graylog2-standalone

# Create Replica Cluster

# On Secondary Servers
./RUNME.sh up mongodb

# On Primary
./RUNME.sh up mongodb
MONGODOCKERNAME="$(./RUNME.sh ps | grep -i mongo | awk '{print $1}')"
docker exec -it $MONGODOCKERNAME /bin/bash

mongo -u "superadmin" -p "${MONGODB_SUPERADMIN_PW}" --authenticationDatabase "admin"
rs.add("<SERVER2>")
rs.add("<SERVER3>")


# DROP DATABASE CONTENTS

use Graylog
db.getCollectionNames().forEach(function(c) { if (c.indexOf("system.") == -1) db[c].drop(); })

# DATABASE COMMANDS
show dbs
use <db>
show collections
