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
    class Apache < Vito::Recipe
      def run
        if installed?
          Vito::Log.write "Apache2 already installed."
        else
          Vito::Log.write "Installing Apache2"
          install_os_dependencies
          install
        end
      end

      private

      def install
        # OS dependency
        #
        # $ sudo apt-get install -y libcurl4-openssl-dev
        #

        # ---

        # Install Apache
        #
        # $ sudo apt-get install -y apache2 apache2-mpm-prefork apache2-prefork-dev

        # ---

        # Install passenger
        #
        # $ gem install passenger && rbenv rehash
        #
        # Then run it:
        #
        # $ passenger-install-apache2-module
        #
        # We need to deal with the setup screen.

        # ---

        # Paste these lines in the following files:
        #
        # * /etc/apache/mods-available/passenger.load
        #
        # LoadModule passenger_module /home/deploy/.rbenv/versions/2.0.0-p247/lib/ruby/gems/2.0.0/gems/passenger-4.0.10/buildout/apache2/mod_passenger.so
        #
        # * /etc/apache/mods-available/passenger.conf
        #
        # PassengerRoot /home/deploy/.rbenv/versions/2.0.0-p247/lib/ruby/gems/2.0.0/gems/passenger-4.0.10
        # PassengerDefaultRuby /home/deploy/.rbenv/versions/2.0.0-p247/bin/ruby
        #
        # Replace the paths with the according Passenger path.
        #
        # Then:
        #
        # $ sudo a2enmod passenger
        #
        # Then:
        #
        # $ sudo service apache2 restart

        # ---

        # For VHosts, create a file in /etc/apache2/sites-available/vito_site,
        #
        #
        #
        #
        #
        #
        #
        # And then:
        #
        # $ sudo a2ensite vito_site
        #
        # Then:
        #
        # $ sudo service apache2 restart

        # ---

      end

      def install
      end

      def os_dependencies
        %w(libpq-dev postgresql-contrib)
      end
    end
  end
end
