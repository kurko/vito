module RSpecSupport
  module Vagrant
    def connection
      'ssh -i ~/.vagrant.d/insecure_private_key vagrant@localhost -p2222'
    end

    def setup_vagrant
      system_command("vagrant up")
      raise "Box not working" unless vagrant_command("ls")
      reboot_vagrant_box
    end

    def assert_installation(command)
      vagrant_command(command)
    end

    def reboot_vagrant_box
      system_command("vagrant snapshot go initial_box")
    end

    private

    def system_command(command)
      stdin, stdout, stderr, thread = Open3.popen3(command)
      thread.value.exitstatus == 0
    end

    def vagrant_command(command)
      command = "#{connection} #{command}"
      stdin, stdout, stderr, thread = Open3.popen3(command)
      thread.value.exitstatus == 0
    end
  end
end
