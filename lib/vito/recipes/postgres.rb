module Vito
  module Recipes
    class Postgres < Vito::Recipe
      def install
        if installed?
          Vito::Log.write "Postgres already installed."
        else
          Vito::Log.write "Installing Postgres"
          install_os_dependencies
          install_postgres
        end
      end

      private

      def postgres_installed?
        @memo ||= query("psql --version").success?
      end

      def user_exists?
        query("sudo su - postgres -c \"psql -tAc \\\\\"SELECT 1 FROM pg_roles WHERE rolname='#{username}'\\\\\" | grep -q 1 || echo 'hey'\"").result == ""
      end

      def utf_template?
        query("sudo su - postgres -c \"psql -d template1 -c \\\\\"SHOW SERVER_ENCODING;\\\\\" | grep -q UTF || echo 'hey'\"").result == ""
      end

      def installed?
        # Only verifies Postgres configuration if it's installed
        if postgres_installed?
          Vito::Log.write "User doesn't exist. I will create one." unless user_exists?
          Vito::Log.write "template1 database's encoding should be UTF-8. I'll adjust this." unless utf_template?
        end

        postgres_installed? &&
          user_exists? &&
          utf_template?
      end

      def username
        "vitouser"
      end

      def password
        "123456"
      end

      def install_postgres
        string = []
        run_command "sudo apt-get install -y postgresql-9.1 libpq-dev"

        # Create user only if it doesn't exist yet
        unless user_exists?
          string << "sudo su - postgres -c \"createuser -d -r -s #{username}\""
        end

        run_command(string.join(" && ")) unless string.empty?
        convert_template1_to_utf8 unless utf_template?
        string = []

        if os.is?(:ubuntu, "10")
          string << "sudo /etc/init.d/postgresql restart"
        else
          string << "sudo service postgresql restart"
        end
        run_command "sudo su - postgres -c \"psql -d template1 -c \\\\\"alter user #{username} with password '#{password}'\\\\\";\""

        run_command(string.join(" && "))
      end

      def install_os_dependencies
        return if postgres_installed?
        Vito::Log.write "Installing some OS dependencies first"
        if os.is?(:ubuntu, "10")
          run_command("sudo apt-get remove -y postgresql")
          run_command("sudo apt-get autoremove -y")
          run_command("sudo apt-get install -y python-software-properties")
          run_command("sudo add-apt-repository ppa:pitti/postgresql && sudo apt-get update")
        end

        super(os_dependencies)
      end

      def os_dependencies
        %w(libpq-dev postgresql-contrib)
      end

      def convert_template1_to_utf8
        # In some cases, the OS locale won't be compatible with UTF-8. When
        # creating a database, Rails will try to use Postgres' template1 with
        # UTF-8.
        #
        # Here, we delete template1, then login in template0 to recreate
        # template1 with UTF-8 encoding.
        run_command "sudo su - postgres -c \"psql -d template1 -c \\\\\"UPDATE pg_database SET datallowconn = TRUE where datname = 'template0';\\\\\"\""
        run_command "sudo su - postgres -c \"psql -d template0 -c \\\\\"UPDATE pg_database SET datistemplate = FALSE where datname = 'template1'; \\\\\"\""
        run_command "sudo su - postgres -c \"psql -d template0 -c \\\\\"drop database template1; \\\\\"\""
        run_command "sudo su - postgres -c \"psql -d template0 -c \\\\\"create database template1 with template = template0 encoding = 'UNICODE'  LC_CTYPE = 'en_US.UTF-8' LC_COLLATE = 'C'; \\\\\"\""
        run_command "sudo su - postgres -c \"psql -d template0 -c \\\\\" UPDATE pg_database SET datistemplate = TRUE where datname = 'template1'; \\\\\"\""
        run_command "sudo su - postgres -c \"psql -d template1 -c \\\\\" UPDATE pg_database SET datallowconn = FALSE where datname = 'template0'; \\\\\"\""
      end
    end
  end
end
