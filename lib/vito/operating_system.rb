module Vito
  class OperatingSystem
    def initialize(requestor)
      @requestor = requestor
    end

    def install_dependencies(dependencies)
      
        sudo apt-get install -y
    end
  end
end
