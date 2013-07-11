module Vito
  module Recipes
    class Ruby < Vito::Recipe
      def run
        Vito::Log.write "Installing Ruby"
        install_os_dependencies
        #install_git
        install_rbenv
      end

      def install_rbenv
        install_recipe(:rbenv)
      end

      private

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
