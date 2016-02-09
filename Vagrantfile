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
  # Node 1
  ########
  config.vm.define "node1", primary: true do |v|
    v.vm.provision :shell, :path => "bootstrap_nodes.sh"
    v.vm.network "private_network", ip: "10.1.2.11"
    v.vm.box = "ubuntu/trusty64"
    v.vm.hostname = "node1"

    if VAGRANT_COMMAND == "ssh"
      config.ssh.username = 'mpiuser'
      config.ssh.password = "password1234"
      config.ssh.insert_key = 'true'
    end

    v.vm.provider "virtualbox" do |vb|
      vb.customize [
                    "modifyvm", :id,
                    "--memory", "512"
                   ]
    end
  end

  ########
  # Node 2
  ########
  config.vm.define "node2", primary: true do |v|
    v.vm.provision :shell, :path => "bootstrap_nodes.sh"
    v.vm.network "private_network", ip: "10.1.2.12"
    v.vm.box = "ubuntu/trusty64"
    v.vm.hostname = "node2"

    if VAGRANT_COMMAND == "ssh"
      config.ssh.username = 'mpiuser'
      config.ssh.password = 'password1234'
      config.ssh.insert_key = 'true'
    end

    v.vm.provider "virtualbox" do |vb|
      vb.customize [
        "modifyvm", :id,
        "--memory", "512"
      ]
    end
  end

  ########
  # Node 3
  ########
  config.vm.define "node3", primary: true do |v|
    v.vm.provision :shell, :path => "bootstrap_nodes.sh"
    v.vm.network "private_network", ip: "10.1.2.13"
    v.vm.box = "ubuntu/trusty64"
    v.vm.hostname = "node3"

    if VAGRANT_COMMAND == "ssh"
      config.ssh.username = 'mpiuser'
      config.ssh.password = 'password1234'
      config.ssh.insert_key = 'true'
    end

    v.vm.provider "virtualbox" do |vb|
      vb.customize [
        "modifyvm", :id,
        "--memory", "512"
      ]
    end
  end

  ########
  # Node 4
  ########
  config.vm.define "node4", primary: true do |v|
    v.vm.provision :shell, :path => "bootstrap_nodes.sh"
    v.vm.network "private_network", ip: "10.1.2.14"
    v.vm.box = "ubuntu/trusty64"
    v.vm.hostname = "node4"

    if VAGRANT_COMMAND == "ssh"
      config.ssh.username = 'mpiuser'
      config.ssh.password = 'password1234'
      config.ssh.insert_key = 'true'
    end

    v.vm.provider "virtualbox" do |vb|
      vb.customize [
        "modifyvm", :id,
        "--memory", "512"
      ]
    end
  end

  ########
  # Node 5
  ########
  config.vm.define "node5", primary: true do |v|
    v.vm.provision :shell, :path => "bootstrap_nodes.sh"
    v.vm.network "private_network", ip: "10.1.2.15"
    v.vm.box = "ubuntu/trusty64"
    v.vm.hostname = "node5"

    if VAGRANT_COMMAND == "ssh"
      config.ssh.username = 'mpiuser'
      config.ssh.password = 'password1234'
      config.ssh.insert_key = 'true'
    end

    v.vm.provider "virtualbox" do |vb|
      vb.customize [
        "modifyvm", :id,
        "--memory", "512"
      ]
    end
  end

  ########
  # Node 6
  ########
  config.vm.define "node6", primary: true do |v|
    v.vm.provision :shell, :path => "bootstrap_nodes.sh"
    v.vm.network "private_network", ip: "10.1.2.16"
    v.vm.box = "ubuntu/trusty64"
    v.vm.hostname = "node6"

    if VAGRANT_COMMAND == "ssh"
      config.ssh.username = 'mpiuser'
      config.ssh.password = 'password1234'
      config.ssh.insert_key = 'true'
    end

    v.vm.provider "virtualbox" do |vb|
      vb.customize [
        "modifyvm", :id,
        "--memory", "512"
      ]
    end
  end

  ########
  # Node 7
  ########
  config.vm.define "node7", primary: true do |v|
    v.vm.provision :shell, :path => "bootstrap_nodes.sh"
    v.vm.network "private_network", ip: "10.1.2.17"
    v.vm.box = "ubuntu/trusty64"
    v.vm.hostname = "node7"

    if VAGRANT_COMMAND == "ssh"
      config.ssh.username = 'mpiuser'
      config.ssh.password = 'password1234'
      config.ssh.insert_key = 'true'
    end

    v.vm.provider "virtualbox" do |vb|
      vb.customize [
        "modifyvm", :id,
        "--memory", "512"
      ]
    end
  end

  ########
  # Node 8
  ########
  config.vm.define "node8", primary: true do |v|
    v.vm.provision :shell, :path => "bootstrap_nodes.sh"
    v.vm.network "private_network", ip: "10.1.2.18"
    v.vm.box = "ubuntu/trusty64"
    v.vm.hostname = "node8"

    if VAGRANT_COMMAND == "ssh"
      config.ssh.username = 'mpiuser'
      config.ssh.password = 'password1234'
      config.ssh.insert_key = 'true'
    end

    v.vm.provider "virtualbox" do |vb|
      vb.customize [
        "modifyvm", :id,
        "--memory", "512"
      ]
    end
  end

end
