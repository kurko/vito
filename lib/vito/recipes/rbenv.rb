module Vito
  module Recipes
    class Rbenv < Vito::Recipe
      def run
        if rbenv_installed?
          Vito::Log.write "Rbenv already installed."
        else
          Vito::Log.write "Installing Rbenv"
          depends_on_recipe(:git)
          install_rbenv
          install_ruby_build
        end
      end

      private

      def rbenv_installed?
        string = []
        string << "cd ~/"
        string << "rbenv commands"
        query(string.join(" && ")).success?
      end

      def install_rbenv
        puts "Installing Rbenv..."
        string = []
        # TODO verify if this folder already exists
        run_command "git clone git://github.com/sstephenson/rbenv.git ~/.rbenv"

        # TODO verify if .bashrc already have these lines
        string = []
        string << "echo 'eval \"$(rbenv init -)\"' | cat - ~/.bashrc > vitotemp && mv vitotemp ~/.bashrc"
        string << "echo 'export PATH=\"\\$HOME/.rbenv/bin:\\$PATH\"' | cat - ~/.bashrc > vitotemp && mv vitotemp ~/.bashrc"

        run_command string.join(" && ")
      end

      def install_ruby_build
        puts "Installing ruby-build embedded into rbenv..."
        string = []
        # TODO verify if this dir already exists
        string << "git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build"
        run_command string.join(" && ")
      end
    end
  end
end
