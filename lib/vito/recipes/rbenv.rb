module Vito
  module Recipes
    class Rbenv
      def initialize(requestor)
        @requestor = requestor
      end

      def run
        unless rbenv_installed?
          install_rbenv
          install_ruby_build
        end
      end

      def rbenv_installed?
        string = []
        string << "cd ~/"
        string << "rbenv commands"
        result = ssh(string.join(" && "))
        result[2] === 0
      end

      def install_rbenv
        puts "Installing rbenv..."
        string = []
        string << "cd ~/"
        string << "git clone git://github.com/sstephenson/rbenv.git .rbenv"
        string << "echo 'export PATH=\"$HOME/.rbenv/bin:$PATH\"' >> ~/.bashrc"
        string << "echo 'eval \"$(rbenv init -)\"' >> ~/.bashrc"
        string << "exec $SHELL"
        ssh string.join(" && ")
      end

      def install_ruby_build
        puts "Installing ruby-build embedded into rbenv..."
        string = []
        string << "cd ~/"
        string << "git clone git://github.com/sstephenson/ruby-build.git"
        string << "cd ruby-build"
        string << "sudo ./install.sh"
        string << "rm -Rf ruby-build"
        ssh string.join(" && ")
      end

      def ssh(command)
        @requestor.ssh command
      end
    end
  end
end
