module Vito
  module Recipes
    class Rbenv < Vito::Recipe
      def run
        unless rbenv_installed?
          install_rbenv
          install_ruby_build
        end
      end

      private

      def rbenv_installed?
        string = []
        string << "cd ~/"
        string << "rbenv commands"
        result = run_command(string.join(" && "))
        result
      end

      def install_rbenv
        puts "Installing rbenv..."
        string = []
        string << "git clone git://github.com/sstephenson/rbenv.git ~/.rbenv"
        string << "echo 'export PATH=\"\\$HOME/.rbenv/bin:\\$PATH\"' >> ~/.profile"
        string << "echo 'eval \"$(rbenv init -)\"' >> ~/.profile"
        string << "exec \\$SHELL -l"
        run_command string.join(" && ")
      end

      def install_ruby_build
        puts "Installing ruby-build embedded into rbenv..."
        string = []
        string << "git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build"
        run_command string.join(" && ")
      end
    end
  end
end
