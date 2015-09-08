FROM mbentley/oracle-jdk7:latest
MAINTAINER Matt Bentley <mbentley@mbentley.net>

ENV TOMCATVER 7.0.64

RUN (apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install patch wget)
RUN (wget -O /tmp/tomcat7.tar.gz http://www.us.apache.org/dist/tomcat/tomcat-7/v${TOMCATVER}/bin/apache-tomcat-${TOMCATVER}.tar.gz &&\
  cd /opt &&\
  tar zxf /tmp/tomcat7.tar.gz &&\
  rm /tmp/tomcat7.tar.gz &&\
  mv /opt/apache-tomcat* /opt/tomcat)

ADD ./run.sh /usr/local/bin/run

ADD server.xml.patch /tmp/server.xml.patch
RUN (patch -N /opt/tomcat/conf/server.xml /tmp/server.xml.patch && rm /tmp/server.xml.patch)

### to deploy a specific war to ROOT, uncomment the following 2 lines and specify the appropriate .war
#RUN rm -rf /opt/tomcat/webapps/docs /opt/tomcat/webapps/examples /opt/tomcat/webapps/ROOT
#ADD yourfile.war /opt/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["/usr/local/bin/run"]
