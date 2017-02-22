FROM jenkins

COPY init.groovy.d/* /usr/share/jenkins/ref/init.groovy.d/
COPY default-plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

