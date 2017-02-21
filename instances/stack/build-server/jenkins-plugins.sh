#! /bin/bash

# Base: https://github.com/jenkinsci/docker/blob/master/plugins.sh

set -e

JENKINS_UC="https://updates.jenkins-ci.org/download"
JENKINS_HOME="/var/lib/jenkins"

while read spec || [ -n "$spec" ]; do
    plugin_rec=(${spec//:/ });
	plugin_name=${plugin_rec[0]}
	plugin_version=${plugin_rec[1]}
	echo "Checking $plugin_name:$plugin_version"
    [[ $plugin_name =~ ^# ]] && continue
    [[ $plugin_name =~ ^\s*$ ]] && continue
    [[ -z $plugin_version ]] && plugin_version="latest"
    echo "Downloading $plugin_name:$plugin_version"
	touch $JENKINS_HOME/plugins/$plugin_name.jpi.pinned 
    wget -q ${JENKINS_UC}/plugins/$plugin_name/$plugin_version/$plugin_name.hpi -O $JENKINS_HOME/plugins/$plugin_name.jpi
    unzip -qqt $JENKINS_HOME/plugins/$plugin_name.jpi
done  < $1

