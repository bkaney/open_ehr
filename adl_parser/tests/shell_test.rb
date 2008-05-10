require 'lib/shell.rb'
require 'test/unit'

class ShellADLValidatorTest < Test::Unit::TestCase
  def setup
    @adl_validator = ::OpenEHR::Application::ADLValidator.new(::OpenEHR::ADL::Validator.new(::OpenEHR::ADL::Parser.new))
    @file = File.open('tests/openEHR-EHR-CLUSTER.exam-nervous_system.v1.adl')
    @string = File.read('tests/openEHR-EHR-CLUSTER.exam-nervous_system.v1.adl')
    @stringio = StringIO.new(@string)
  end

  def test_init
    assert_instance_of ::OpenEHR::Application::ADLValidator,@adl_validator
  end

  def test_run
    assert_nothing_raised do
      @adl_validator.run(@file)
    end
    assert_nothing_raised do
      @adl_validator.run(@string)
    end
    assert_nothing_raised do
      @adl_validator.run(@stringio)
    end
  end
end
