#!/usr/bin/env rake
require "bundler/gem_tasks"

def take_snapshot(name = "vito_snapshot")
  puts "Installing vagrant-vbox-snapshot to take a snapshot"
  system "vagrant plugin install vagrant-vbox-snapshot"

  puts "Taking a snapshot of the current vm state"
  system "vagrant snapshot take #{name}"
end

desc "Sets up a Vagrant box for running specs"
namespace :setup do
  task :download_vagrant_box do
    # list of boxes http://www.vagrantbox.es/
    puts "Downloading Vagrant box called ubuntu_spec_box"
    system "vagrant box add ubuntu_spec_box http://puppet-vagrant-boxes.puppetlabs.com/ubuntu-server-12042-x64-vbox4210-nocm.box"
    puts "Initializing box with Vagrant"
    system "vagrant init ubuntu_spec_box"
    take_snapshot("initial_box")
  end
end

namespace :vagrant do
  desc "Creates a snapshot of the current box state to be used in specs"
  task :take_snapshot do
    take_snapshot("initial_box")
  end
end

namespace :spec do
  desc "Runs all specs"
  task all: ["spec:unit", "spec:acceptance"]

  desc "Runs specs by setting up a Vagrant box and installing recipes in it (could take minutes)"
  task :acceptance do
    puts "Running spec using Vagrant boxes (this could take several minutes)"
    system "bundle exec rspec spec/acceptance"
    fail if $?.exitstatus > 0
  end

  desc "Runs unit specs (no Vagrant box required)"
  task :unit do
    puts "Running unit specs"
    system "bundle exec rspec spec/vito"
    fail if $?.exitstatus > 0
  end
end

task default: ["spec:unit"]
