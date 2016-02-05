# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  config.ssh.forward_x11 = "true"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.provider "virtualbox" do |v|
    v.memory = 512
    v.cpus = 1
  end

  config.vm.define "master", primary: true do |v|
    v.vm.provision :shell, :path => "bootstrap_master.sh"
    v.vm.network "private_network", ip: "10.1.2.10"
    v.vm.box = "ubuntu/trusty64"
    v.vm.hostname = "master"

    v.vm.provider "virtualbox" do |vb|
      vb.customize [
                    "modifyvm", :id,
                    "--memory", "512"
                   ]
    end
  end

    config.vm.define "node1", primary: true do |v|
    v.vm.provision :shell, :path => "bootstrap_node.sh"
    v.vm.network "private_network", ip: "10.1.2.11"
    v.vm.box = "ubuntu/trusty64"
    v.vm.hostname = "node1"

    v.vm.provider "virtualbox" do |vb|
      vb.customize [
                    "modifyvm", :id,
                    "--memory", "512"
                   ]
    end
  end

end
