DB_VENDOR=$1

cd /opt/jboss/wildfly

bin/jboss-cli.sh --file=cli/databases/$DB_VENDOR/standalone-configuration.cli
rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history
