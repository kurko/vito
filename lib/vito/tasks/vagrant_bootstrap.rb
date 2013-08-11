module Vito
  module Tasks
    class VagrantBootstrap
      def initialize(os_name)
        @os_name = os_name
      end

      def install
        puts "Initializing #{os_name} box called #{os_name}_test_box into: #{box_location(os_name)}"
        pwd = Dir.pwd
        Dir.chdir("spec/vagrant_boxes/#{os_name}")

        puts "Attempting to download and prepare the box..."
        system "vagrant up && vagrant halt"
        puts "Attempting to take snapshot of clean box..."
        install_snapshot_plugin
        system "vagrant snapshot take #{snapshot_name}" unless snapshot_exist?

        puts "Done.\n"
        Dir.chdir(pwd)
      end

      private

      attr_reader :os_name

      def install_snapshot_plugin
        snapshot_plugin_name = "vagrant-vbox-snapshot"
        unless system("vagrant plugin list|grep #{snapshot_plugin_name} &> /dev/null && echo 1")
          system("vagrant plugin install vagrant-vbox-snapshot")
        end
      end

      def snapshot_exist?
        `vagrant snapshot list|grep #{snapshot_name} &> /dev/null && echo 1`
        $?.success?
      end

      def snapshot_name
        "#{os_name}_initial_box"
      end

      def box_location(os)
        "spec/vagrant_boxes/#{os}"
      end
    end
  end
end
