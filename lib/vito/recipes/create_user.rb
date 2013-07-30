module Vito
  module Recipes
    class CreateUser < Vito::Recipe
      def run
        if ruby_exists?
          Vito::Log.write "Ruby version #{version} is already installed."
        else
          Vito::Log.write "Installing Ruby"
          install_os_dependencies
          depends_on_recipe(:rbenv)
          install_ruby
        end
      end

      def create
        # sudo groupadd -r admin
        #
        # Sudo group in Ubuntu 12.04 or newer: admin
        # older: sudo
        os.create_admin_group

        # ----

        # Creates user deploy in the admin group
        #
        # sudo useradd --groups admin -r deploy
        # $ sudo useradd --groups admin -m -r deploy
        #
        # -m creates /home/deploy
        # -r creates user as system user
        os.create_admin_user(:deploy)

        # ----

        # For a new user to be able to access via SSH, you have to create a
        # password for him:
        #
        # $ passwd deploy
        #
        # Will prompt for a password. Use 123456 by default

        # ----

        # To avoid requesting password for Sudo users
        #
        # $ sudo visudo
        #
        # Add the following line at the end
        #
        #   deploy ALL=(ALL) NOPASSWD: ALL
        #
        # Or:
        #
        # $ echo "deploy ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

        # ----

        # To verify if a user has SSH access
        #
        # $ grep -i "deploy" /etc/shadow | awk -F':' '{ print $2 }'
        #
        # If it returns !, it doesn't have access
      end

      private

    end
  end
end
