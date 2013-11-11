# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu-base-oss"
  config.vm.box_url = "http://vagrantboxes.derecom.it/boxes/ubuntu-base-oss.box"
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "test"
    puppet.manifest_file  = "test_vm.pp"
  end
end
