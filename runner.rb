require 'forerunner'

class Runner
  def initialize
    fr = Forerunner.new
    fr.boot
    fr.list
  end
end
