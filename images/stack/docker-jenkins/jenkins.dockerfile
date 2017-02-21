FROM jenkins

COPY init.groovy.d/* /var/jenkins_home/init.groovy.d/
RUN chown jenkins:jenkins /var/jenkins_home/init.groovy.d/
