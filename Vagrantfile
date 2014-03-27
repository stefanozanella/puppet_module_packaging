# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu-1310-x64-virtualbox-puppet"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-1310-x64-virtualbox-puppet.box"
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "test"
    puppet.manifest_file  = "test_vm.pp"
  end
end
