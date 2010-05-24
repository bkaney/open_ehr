require File.dirname(__FILE__) + '/test_helper.rb'

class ADLSemanticTest < Test::Unit::TestCase
  def setup
    @parser = ::OpenEHR::ADL::Parser.new
  end

  must "assert adl parser instance" do
    assert_instance_of ::OpenEHR::ADL::Parser,@parser
  end
end
