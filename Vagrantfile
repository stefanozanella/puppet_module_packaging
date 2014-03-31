# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "puppetlabs/ubuntu-13.10-x86_64-puppet"
  config.vbguest.auto_update = false
  config.vm.provision "puppet" do |puppet|
    puppet.manifests_path = "test"
    puppet.manifest_file  = "test_vm.pp"
  end
end
