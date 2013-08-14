module Vito
  module Recipes
    module Ruby
      class Install < Vito::Recipe
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
          version_to_install = version
          if version_to_install.nil?
            version_to_install = "2.0.0-p247"
            Vito::Log.write "No Ruby version specified, installing #{version_to_install}."
          end
          string = []
          string << "rbenv install #{version_to_install}"
          string << "rbenv global #{version_to_install}"
          string << "rbenv rehash"
          string << "gem install bundler"
          run_command string.join(" && ")
        end

        private

        def ruby_exists?
          if version.nil?
            if @options[:dependent]
              Vito::Log.write "#{@options[:dependent]} requires Ruby, but didn't specify a version."
            else
              Vito::Log.write "No Ruby version specified. Checking for any version instead."
            end
          end
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
end
