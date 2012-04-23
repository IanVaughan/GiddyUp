require 'app_conf'

module GiddyUp
  class Config

    def initialize
      @conf = AppConf.new
    end

    def load file
      @conf.load file
    end

    def save
    end

  end
end
