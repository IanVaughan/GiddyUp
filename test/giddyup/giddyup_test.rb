require "test/unit"
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/../../lib')

require 'giddyup'

module GiddyUp
  class GiddyUp < Test::Unit::TestCase

    def test_simple
      puts self
      self.GiddyUp.init_logger

      assert_equal 1, 2
    end
  end
end
