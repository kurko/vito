#!/usr/bin/env rake
require "bundler/gem_tasks"

desc "Sets up a Vagrant box for running specs"
namespace :setup do
  task :download_vagrant_box do
    # list of boxes http://www.vagrantbox.es/
    puts "Downloading Vagrant box called ubuntu_spec_box"
    system "vagrant box add ubuntu_spec_box http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210-nocm.box"
    puts "Initializing box with Vagrant"
    system "vagrant init ubuntu_spec_box"
  end
end
