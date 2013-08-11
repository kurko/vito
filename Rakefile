#!/usr/bin/env rake
require "bundler/gem_tasks"
require "vito/tasks/vagrant_bootstrap"

desc "Sets up a Vagrant box for running specs"
namespace :setup do
  task :download_vagrant_box do
    # list of boxes http://www.vagrantbox.es/
    Vito::Tasks::VagrantBootstrap.new(:ubuntu10).install
    Vito::Tasks::VagrantBootstrap.new(:ubuntu12).install
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
