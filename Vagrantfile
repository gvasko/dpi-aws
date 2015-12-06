#############################
#	Vagrantfile for AWS CLI	#
#############################

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Prerequisites:
#	Vagrant and VirtualBox

# Vagrantfile API/syntax version. 
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.box = "hashicorp/precise32"
	config.vm.provision :shell, path: "vagrant/provision.sh"
end
