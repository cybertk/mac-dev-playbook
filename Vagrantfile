# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define "osx-ci-runner-template"
  config.vm.box = "osx-dev"

  # NFS requires a host-only network
  config.vm.network "private_network", ip: "192.168.33.10"

  # Use NFS for the shared folder
  config.vm.synced_folder ".", "/vagrant",
    id: "core",
    :nfs => true,
    :mount_options => ['nolock,vers=3,udp,noatime']

  config.vm.provider "virtualbox" do |vb|
    vb.name = "osx-ci-runner-template"

    # Customize the amount of memory and cpus on the VM:
    vb.memory = 4096
    vb.cpus = 2

    # Default 9m vram will cause system hang with black screen
    vb.customize ["modifyvm", :id, "--vram", "128"]
  end

  # Provision with Ansible
  # config.vm.provision "ansible" do |ansible|
  #   ansible.playbook = "main.yml"
  # end
end
