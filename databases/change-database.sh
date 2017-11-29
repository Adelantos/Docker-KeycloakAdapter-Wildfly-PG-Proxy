DB_VENDOR=$1

cd /opt/jboss/wildfly

bin/jboss-cli.sh --file=cli/databases/$DB_VENDOR/standalone-configuration.cli
rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history

bin/jboss-cli.sh --file=cli/databases/$DB_VENDOR/standalone-ha-configuration.cli
rm -rf standalone/configuration/standalone_xml_history/current/*
