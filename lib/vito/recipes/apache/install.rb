module Vito
  module Recipes

    # Example VHosts files
    #
    # <VirtualHost *:80>
    #    ServerName www.yourhost.com
    #    # !!! Be sure to point DocumentRoot to 'public'!
    #    DocumentRoot /somewhere/public
    #    <Directory /somewhere/public>
    #      # This relaxes Apache security settings.
    #      AllowOverride all
    #      # MultiViews must be turned off.
    #      Options -MultiViews
    #   </Directory>
    # </VirtualHost>
    #
    module Apache
      class Install < Vito::Recipe
        APACHE_HOMEDIR = "/etc/apache2"

        def install
          if installed?
            Vito::Log.write "Apache2 already installed."
          else
            Vito::Log.write "Installing Apache2"
            install_apache
          end
        end

        # Used in the Apache block
        def vhosts(options = {})
          @vhosts = {}
          @vhosts[:rails_env]  = options[:rails_env]  || "production"
          @vhosts[:servername] = options[:servername] || "www.example.com"

          @vhosts[:ports] = options[:ports] || [80]
          @vhosts[:ports] << 443 if Array(options[:with]).include?(:ssl)

          @vhosts[:path] = options[:path]

          raise InvalidApacheVhosts, "VHosts' app path not specified" unless @vhosts[:path]
          raise InvalidApacheVhosts, "VHosts' app port not specified" unless @vhosts[:ports]
        end


        private

        def installed?
          false
        end

        def install_apache

          # OS dependency
          #
          install_os_dependencies(os_dependencies)

          # Install Apache
          #
          run_command "sudo apt-get install -y apache2 apache2-mpm-prefork apache2-prefork-dev"

          # Install passenger
          #if install_passenger?
            depends_on_recipe(:passenger, server: :apache)
          #end

          # CONFIGURES APACHE

          # VHOSTS
          #
          # Disable the old 000-default site
          #
          run_command "sudo a2dissite 000-default"

          if @vhosts
            Vito::Log.write("Setting up Apache's VHosts")

            #
            # For VHosts, create a file in /etc/apache2/sites-available/vito_site
            #
            vhosts_template_file = "vito_rails_site"
            created_vhosts = []

            @vhosts[:ports].each do |port|
              vhosts_file = "#{vhosts_template_file}_#{port}"

              # Downloads template file
              command = []
              command << "cd #{APACHE_HOMEDIR}/sites-available/"
              command << "sudo curl https://raw.github.com/kurko/vito/master/templates/apache2/#{vhosts_template_file} -O"
              command << "sudo mv #{vhosts_template_file} #{vhosts_file}"
              run_command command.join(" && ")

              path = @vhosts[:path].gsub(/\//, '\/')
              command = []
              command << "cd #{APACHE_HOMEDIR}/sites-available/"
              command << "sudo sed -i 's/{{VITO_PORT}}/#{port.to_i}/' #{vhosts_file}"
              command << "sudo sed -i 's/{{VITO_SERVERNAME}}/#{@vhosts[:servername].gsub(/\//, "\/")}/' #{vhosts_file}"
              command << "sudo sed -i 's/{{VITO_RAILS_PUBLIC_PATH}}/#{path}/g' #{vhosts_file}"
              command << "sudo sed -i 's/{{VITO_RAILS_ENV}}/#{@vhosts[:rails_env].gsub(/\//, "\/")}/' #{vhosts_file}"
              run_command command.join(" && ")

              created_vhosts << vhosts_file
            end

          end

          # Replace the paths with whatever is passed in the vito.rb. Then create
          # the path. Let's say it's /var/projects/, run:
          #
          # Considering the user 'deploy' and the group 'admin'
          #
          run_command "[ -d #{@vhosts[:path]} ] || sudo mkdir #{@vhosts[:path]}"
          run_command "sudo chown \\$USER:admin #{@vhosts[:path]}"

          if @vhosts
            Vito::Log.write("Activating Apache's VHosts")

            command = []
            created_vhosts.each do |file|
              command << "sudo a2ensite #{file}"
            end

            if command.empty?
              Vito::Log.write("*** No files to activate? ***")
            else
              run_command(command.join(" && "))
            end
          end

          # Then restart apache
          #
          os.service(:apache2, :restart)

        end

        def os_dependencies
          %w(libcurl4-openssl-dev curl)
        end
      end
    end
  end
end
