FROM jenkins

COPY init.groovy.d/* /usr/share/jenkins/ref/init.groovy.d
