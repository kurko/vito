module Vito
  module Recipes
    class Ruby
      attr_reader :installed_apps

      def initialize(delegator)
        @delegator = delegator
        @installed_apps = []
      end

      def add_installed_app(app)
        @installed_apps << app
      end

      def ensure_installed_app(app)
        
      end

      def run
        Vito::Output.write "Starting Ruby installation"
        install_os_dependencies
        install_git
        install_rbenv
      end

      def install_git
        Vito::Recipes::Git.new(self).run
      end

      def install_rbenv
        Vito::Recipes::Rbenv.new(self).run
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
