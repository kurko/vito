#!/usr/bin/env rake
require "bundler/gem_tasks"

desc "Sets up a Vagrant box for running specs"
namespace :setup do
  task :download_vagrant_box do
    puts "Downloading http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210-nocm.box"
    system "vagrant box add vagrant_specs_box http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210-nocm.box"
    puts "Initializing box with Vagrant"
    system "vagrant init vagrant_specs_box"
  end
end
