FROM tomcat:9.0.100
COPY target/maven-web-application.war /usr/local/tomcat/webapps/maven-web-application.war
