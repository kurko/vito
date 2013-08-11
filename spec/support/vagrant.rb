module RSpecSupport
  module Vagrant
    def connection(box)
      "ssh -i ~/.vagrant.d/insecure_private_key vagrant@localhost -p#{box.ssh_port}"
    end

    def setup_vagrant(box)
      puts "Starting test on #{box.name}"
      system_command("cd #{box.path} && vagrant up")
      raise "Box not working" unless vagrant_command(box, "ls")
      reboot_vagrant_box(box)
    end

    def assert_installation(box, command)
      vagrant_command(box, command)
    end

    def reboot_vagrant_box(box)
      system_command("cd #{box.path} && vagrant snapshot go #{box.initial_snapshot_name}")
    end

    private

    def system_command(command)
      #stdin, stdout, stderr, thread = Open3.popen3(command)
      #puts stdout.read
      #thread.value.exitstatus == 0
      system(command)
    end

    def vagrant_command(box, command)
      command = "#{connection(box)} #{command}"
      #stdin, stdout, stderr, thread = Open3.popen3(command)
      #puts stdout.read
      #thread.value.exitstatus == 0
      system(command)
    end
  end
end
