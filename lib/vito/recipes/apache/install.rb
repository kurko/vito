module Vito
  module Recipes
    module Apache
      class Install < Vito::Recipe
        APACHE_HOMEDIR = "/etc/apache2"

        def initialize(options, connection)
          @vhosts = {}
          super
        end

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
          if with?(:passenger)
            depends_on_recipe(:passenger, {server: :apache}.merge(passenger))
          end

          # CONFIGURES APACHE
          #
          # VHOSTS
          #
          unless @vhosts.empty?
            Vito::Log.write("Setting up Apache's VHosts")

            #
            # For VHosts, create a file in /etc/apache2/sites-available/vito_site
            #
            # TODO: we shouldn't use Rails unless Passenger is specified
            vhosts_template_file = if rails?
                                     "vito_rails_site"
                                   else
                                     "vito_site"
                                   end
            created_vhosts = []

            @vhosts[:ports].each do |port|
              vhosts_file = "#{vhosts_template_file}_#{port}"

              if site_already_enabled?(vhosts_file)
                Vito::Log.write("#{vhosts_file} Apache site already defined.")
                next
              end
              # Disable the old 000-default site
              #
              run_command "sudo a2dissite 000-default"


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


              # Rails specific
              command << "sudo sed -i 's/{{VITO_RAILS_PUBLIC_PATH}}/#{path}/g' #{vhosts_file}"
              command << "sudo sed -i 's/{{VITO_RAILS_ENV}}/#{@vhosts[:rails_env].gsub(/\//, "\/")}/' #{vhosts_file}"

              # non-Rails
              command << "sudo sed -i 's/{{VITO_SITE_PATH}}/#{path}/g' #{vhosts_file}"

              run_command command.join(" && ")

              created_vhosts << vhosts_file
            end

            # Replace the paths with whatever is passed in the vito.rb. Then create
            # the path. Let's say it's /var/projects/, run:
            #
            # Considering the user 'deploy' and the group 'admin'
            #
            run_command "[ -d #{@vhosts[:path]} ] || sudo mkdir -p #{@vhosts[:path]}"
            run_command "sudo chown \\$USER:admin #{@vhosts[:path]}"

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

        def rails?
          with?(:passenger)
        end

        def site_already_enabled?(site)
          # TODO: apachectl is Ubuntu specific
          query("sudo apachectl -S|grep site").result.match(/#{site}/)
        end
      end
    end
  end
end
