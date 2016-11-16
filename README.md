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
rs.addArb("<ARBITER SERVER>")

# DROP ALL DATABASE (WILL LOSE EVERYTHING)

use Graylog
db.getCollectionNames().forEach(function(c) { if (c.indexOf("system.") == -1) db[c].drop(); })

curl -XDELETE 'http://<ES_SERVER>:9200/graylog'

# RECONFIGURE PRIORITY

cfg = rs.conf()
cfg.members[0].priority = 10
cfg.members[1].priority = 5
cfg.members[2].priority = 2
rs.reconfig(cfg)

# DATABASE COMMANDS
show dbs
use <db>
show collections

