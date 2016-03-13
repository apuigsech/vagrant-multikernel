# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define "multikernel-linux32", primary: true  do |multikernel_linux32|
    multikernel_linux32.vm.box = "ubuntu/trusty32"
  end

  #config.vm.define "multikernel-linux64" do |multikernel_linux64|
  #  ctf_linux64.vm.box = "ubuntu/trusty64"
  #end

  config.ssh.forward_x11 = true
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.gui = true
  end

  config.vm.provision "file", source: "conf", destination: "conf"
  config.vm.provision "file", source: "lib", destination: "lib"
  config.vm.provision "file", source: "bin", destination: "bin"
  config.vm.provision "file", source: "setup.sh", destination: "setup.sh"
  config.vm.provision "shell", path: "setup.sh", privileged: false
end
