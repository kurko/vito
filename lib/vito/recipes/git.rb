module Vito
  module Recipes
    class Git < Vito::Recipe
      def run
        Log.write ""
        Log.write "Starting Git installation..."
        Log.write "Installing OS dependencies"
        install_os_dependencies
        Log.write "Installing Git itself"
        install_git
      end

      private

      def install_git
        string = []
        string << "sudo apt-get install -y git-core"
        string << "git --version"
        run_command(string.join(" && "))
      end

      def os_dependencies
        %w(build-essential openssl libreadline6
           libreadline6-dev zlib1g zlib1g-dev libssl-dev
           libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3
           libxml2-dev libxslt1-dev autoconf libc6-dev
           libncurses5-dev)
      end
    end
  end
end
