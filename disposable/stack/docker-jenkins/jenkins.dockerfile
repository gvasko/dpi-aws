FROM jenkins

COPY init.groovy.d/* /var/jenkins_home/init.groovy.d/

