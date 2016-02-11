# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

VAGRANT_COMMAND = ARGV[0]

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

  #############
  # Node Master
  #############
  config.vm.define "master", primary: true do |v|
    v.vm.provision :shell, :path => "bootstrap_nodes.sh", :args => "-t"
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

  ########
  # Multi-nodes defined in a loop, see
  # * https://www.vagrantup.com/docs/vagrantfile/tips.html
  # for more information
  #######

  (1..4).each do |i|
    config.vm.define "node#{i}" do |v|
      v.vm.provision :shell, :path => "bootstrap_nodes.sh"
      newip = 10 + i
      v.vm.network "private_network", ip: "10.1.2.#{newip}"
      v.vm.box = "ubuntu/trusty64"
      v.vm.hostname = "node#{i}"

      # if VAGRANT_COMMAND == "ssh"
      #  config.ssh.username = 'mpiuser'
      #  config.ssh.password = "password1234"
      #  config.ssh.insert_key = 'true'
      # end
    end
  end

end
