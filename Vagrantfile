# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'etc'

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/bionic64"

  Box = Struct.new(:name, :ip, :hostname, :memory)
  user = Etc.getpwuid
  public_key = File.read("#{user.dir}/.ssh/id_rsa.pub")

  vms = [
    Box.new('web', '172.21.21.10', 'server', 1024),
    Box.new('db', '172.21.21.20', 'db', 1024),
  ]

  vms.each do |box|
    config.vm.define(box.name) do |b|
      b.vm.provider vm_provider
      b.vm.network "private_network", ip: box.ip
      b.vm.provision :shell, path: "provision_vm.sh", privileged: true, args: [
        ENV['USERNAME'], 
        box.hostname, 
        public_key,
        "10.0.2.2", # apt cache machines IP address, w/ virtualbox 10.0.2.2 is the host
      ]
      b.vm.provider :virtualbox do |provider, override|
        provider.memory = box.memory unless box.memory.nil?
      end
    end
  end
end
