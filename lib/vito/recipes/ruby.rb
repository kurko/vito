module Vito
  module Recipes
    class Ruby < Vito::Recipe
      def install
        if ruby_exists?
          Vito::Log.write "Ruby version #{version} is already installed."
        else
          Vito::Log.write "Installing Ruby"
          install_os_dependencies(os_dependencies)
          depends_on_recipe(:rbenv)
          install_ruby
        end
      end

      def install_ruby
        string = []
        string << "rbenv install #{version}"
        string << "rbenv global #{version}"
        string << "rbenv rehash"
        string << "gem install bundler"
        run_command string.join(" && ")
      end

      private

      def ruby_exists?
        program_version("ruby -v").matches?(version)
      end

      def os_dependencies
        %w(build-essential openssl libreadline6
           libreadline6-dev zlib1g zlib1g-dev libssl-dev
           libyaml-dev libsqlite3-0 libsqlite3-dev sqlite3
           libxml2-dev libxslt1-dev autoconf libc6-dev
           libncurses5-dev)
      end

      def version
        @options[:version]
      end
    end
  end
end
