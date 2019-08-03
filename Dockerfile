FROM jboss/wildfly:17.0.1.Final

ENV KEYCLOAK_VERSION 6.0.1
ENV PROXY_ADDRESS_FORWARDING false
USER root

RUN yum install -y epel-release && yum install -y jq && yum clean all

USER jboss

RUN cd /opt/jboss/wildfly && curl -L https://downloads.jboss.org/keycloak/${KEYCLOAK_VERSION}/adapters/keycloak-oidc/keycloak-wildfly-adapter-dist-${KEYCLOAK_VERSION}.tar.gz | tar zx

ADD docker-entrypoint.sh /opt/jboss/

ADD cli /opt/jboss/wildfly/cli
ADD adapter-elytron-install-ha-offline.cli /opt/jboss/wildfly/bin/
RUN cd /opt/jboss/wildfly && bin/jboss-cli.sh --file=cli/standalone-configuration.cli && rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history
#RUN cd /opt/jboss/wildfly && bin/jboss-cli.sh --file=cli/standalone-ha-configuration.cli && rm -rf /opt/jboss/wildfly/standalone-ha/configuration/standalone_xml_history
RUN cd /opt/jboss/wildfly && bin/jboss-cli.sh --file=bin/adapter-elytron-install-offline.cli && rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history
#RUN cd /opt/jboss/wildfly && bin/jboss-cli.sh --file=bin/adapter-elytron-install-ha-offline.cli && rm -rf /opt/jboss/wildfly/standalone-ha/configuration/standalone_xml_history

ENV JDBC_POSTGRES_VERSION 42.2.5

ADD databases/change-database.sh /opt/jboss/wildfly/bin/change-database.sh

RUN mkdir -p /opt/jboss/wildfly/modules/system/layers/base/org/postgresql/jdbc/main; cd /opt/jboss/wildfly/modules/system/layers/base/org/postgresql/jdbc/main; curl -L http://central.maven.org/maven2/org/postgresql/postgresql/${JDBC_POSTGRES_VERSION}/postgresql-${JDBC_POSTGRES_VERSION}.jar > postgres-jdbc.jar
ADD databases/postgres/module.xml /opt/jboss/wildfly/modules/system/layers/base/org/postgresql/jdbc/main

RUN rm -rf /opt/jboss/wildfly/standalone/configuration/standalone_xml_history
RUN rm -rf /opt/jboss/wildfly/standalone_ha/configuration/standalone_xml_history

ENV JBOSS_HOME /opt/jboss/wildfly

EXPOSE 8080

ENTRYPOINT [ "/opt/jboss/docker-entrypoint.sh" ]

CMD ["-b", "0.0.0.0"]
