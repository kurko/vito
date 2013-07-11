class VitoConfig
  def self.config
    config = self.new
    config.connection.merge use: config.config
  end

  attr_reader :config

  def initialize
    @config = {}
    install
  end

  def connection
    { user: "root",
      host: "50.116.3.20"
    }
  end

  def install
    use :ruby, "1.9.3-p125"
  end

  def use(program, *details)
    @config[program.to_sym] = details
  end
end
