# require "giddyup/version"
require 'giddyup/launcher'
require 'giddyup/server'
require 'logger'

module GiddyUp
  class << self
    attr_accessor :launcher, :logger

    def init_logger file, level
      basepath = File.expand_path('..', File.dirname(__FILE__))
      file = File.join(basepath, file) if file.class == String && !file.match(/^[\\\/~]/)
      level = %w{ DEBUG INFO WARN ERROR FATAL }.include?(level.upcase) ? level : "INFO"
      @logger = Logger.new(file)
      @logger.progname = 'giddyup'
      @logger.level = Logger.const_get(level)
      @logger.debug 'Logger Live!'
    end

    # method accessible from Sinatra as defined before run
    def load path
      init_logger "log/giddyup.log", "DEBUG"
      @launcher = Launcher.new path
    end

    def runner
      File.expand_path("../../bin/giddyup-runner", __FILE__)
    end

    def start
      @logger.debug 'start'
      Server.run!
    end
    # Cannot access methods here

  end
end
