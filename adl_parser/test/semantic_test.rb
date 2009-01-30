require 'lib/adl_parser.rb'
require 'test/unit'

class ADLSemanticTest < Test::Unit::TestCase
  def setup
    @parser = ::OpenEHR::ADL::Parser.new
  end

  def test_init
    assert_instance_of ::OpenEHR::ADL::Parser,@parser
  end
end
