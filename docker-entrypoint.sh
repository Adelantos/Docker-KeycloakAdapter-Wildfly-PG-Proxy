#!/bin/bash

if [ "$DB_VENDOR" == "POSTGRES" ]; then
  databaseToInstall="postgres"
elif [ "$DB_VENDOR" == "H2" ]; then
  databaseToInstall=""
else
    if (printenv | grep '^POSTGRES_' &>/dev/null); then
      databaseToInstall="postgres"
    fi
fi

if [ "$databaseToInstall" != "" ]; then
    echo "[WILDFLY DOCKER IMAGE] Using the external $databaseToInstall database"
    /bin/sh /opt/jboss/wildfly/bin/change-database.sh $databaseToInstall
else
    echo "[WILDFLY DOCKER IMAGE] Using the embedded H2 database"
fi

exec /opt/jboss/wildfly/bin/standalone.sh $@
exit $?
