FROM jenkins

COPY init.groovy.d/* /var/jenkins_home/init.groovy.d/
#RUN chown -R jenkins:jenkins /var/jenkins_home/init.groovy.d/
