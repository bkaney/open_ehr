require 'lib/adl_parser.rb'
require 'test/unit'

class ShellADLValidatorTest < Test::Unit::TestCase
  def setup
    @adl_validator = ::OpenEHR::Application::ADLValidator.new(::OpenEHR::ADL::Validator.new(::OpenEHR::ADL::Parser.new))
  end

  def test_init
    assert_instance_of ::OpenEHR::Application::ADLValidator,@adl_validator
  end

  def test_run
    assert_nothing_raised do
      adl_file = File.open('test/adl/openEHR-EHR-CLUSTER.exam-nervous_system.v1.adl')
      @adl_validator.run(adl_file)
    end
    assert_nothing_raised do
      adl_string = File.open('test/adl/openEHR-EHR-CLUSTER.exam-nervous_system.v1.adl')
      @adl_validator.run(adl_string)
    end
    assert_nothing_raised do
      adl_string = File.read('test/adl/openEHR-EHR-CLUSTER.exam-nervous_system.v1.adl')
      stringio = StringIO.new(adl_string)
      @adl_validator.run(stringio)
    end
  end
end
