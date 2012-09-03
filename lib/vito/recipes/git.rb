module Vito
  module Recipes
    class Git
      def initialize(delegator)
        @delegator = delegator
        @installed_apps = []
      end

      def run
        puts "Starting Git installation"
        install_git
      end

      def install_git
        puts "Installing git..."
        string = []
        string << "sudo apt-get install -y git git-core"
        string << "git --version"
        puts ssh(string.join(" && ")).inspect
      end

      def install_os_dependencies
        dependencies = %w( build-essential openssl libreadline6
                           libreadline6-dev zlib1g zlib1g-dev libssl-dev
                           libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3
                           libxml2-dev libxslt1-dev autoconf libc6-dev
                           libncurses5-dev)

        os = Vito::OperatingSystem.new(self).install_dependencies(dependencies)
      end

      def ssh(command)
        @delegator.ssh command
      end
    end
  end
end
