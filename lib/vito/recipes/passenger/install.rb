module Vito
  module Recipes
    module Passenger
      class Install < Vito::Recipe
        class InvalidApacheVhosts < StandardError; end

        def install
          if false # installed?
            Vito::Log.write "Passenger already installed."
          else
            Vito::Log.write "Installing Passenger"
            #depends_on_recipe(:ruby)

            if @options[:server] == :apache
              install_passenger_with_apache2
            end
          end
        end

        private

        def install_passenger_with_apache2

          run_command "gem install passenger && rbenv rehash"
          run_command "passenger-install-apache2-module --auto"

          paths = Paths.new(self)
          mod_passenger   = "LoadModule passenger_module #{paths.mod_passenger(:apache)}"
          passenger_path  = "PassengerRoot #{paths.passenger_path}"

          ruby_paths      = Vito::Recipes::Ruby::Paths.new(self)
          ruby_path       = "PassengerDefaultRuby #{ruby_paths.ruby_path}"

          puts passenger_path
          puts mod_passenger
          puts ruby_path

          # Creates /etc/apache2/mods-available/passenger.load
          #
          passenger_load_file = "/etc/apache2/mods-available/passenger.load"

          query "sudo rm #{passenger_load_file}"
          command = ["sudo touch #{passenger_load_file}"]
          command << "sudo echo #{mod_passenger} " + \
                     "| cat - #{passenger_load_file} > ~/vitotemp"
          command << "sudo mv ~/vitotemp #{passenger_load_file}"

          run_command command.join(" && ")

          query "rm ~/vitofile"

          # Creates /etc/apache2/mods-available/passenger.conf
          #
          passenger_conf_file = "/etc/apache2/mods-available/passenger.conf"

          query "sudo rm #{passenger_conf_file}"
          command = ["sudo touch #{passenger_conf_file}"]
          command << "sudo echo #{passenger_path} " + \
                     "| cat - #{passenger_conf_file} > ~/vitotemp"
          command << "sudo mv ~/vitotemp #{passenger_conf_file}"
          command << "sudo echo #{ruby_path} " + \
                     "| cat - #{passenger_conf_file} > ~/vitotemp"
          command << "sudo mv ~/vitotemp #{passenger_conf_file}"

          run_command command.join(" && ")

          query "rm ~/vitofile"

          # Then active the module
          #
          run_command "sudo a2enmod passenger"
          os.service(:apache2, :restart)

        end

        def os_dependencies
          %w(build-essential libcurl4-openssl-dev curl)
        end
      end
    end
  end
end
