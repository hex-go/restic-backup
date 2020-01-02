#!/usr/bin/env bash



cd /root
docker exec jenkins-dit keytool -import -alias tomcat -keystore $JAVA_HOME/jre/lib/security/cacerts -file /root/tomcat.cer -trustcacerts -storepass changeit -noprompt
git init
git config --global http.sslVerify false

mkdir -p /root/.kube/
cp /var/jenkins_home/helm_tools/config /root/.kube/
cp /var/jenkins_home/helm_tools/helm /usr/local/bin/
