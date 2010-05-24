require File.dirname(__FILE__) + '/test_helper.rb'

class ShellADLValidatorTest < Test::Unit::TestCase
  def setup
    @adl_validator = ::OpenEhr::Application::ADLValidator.new(::OpenEhr::ADL::Validator.new(::OpenEhr::ADL::Parser.new))
  end

  must "assert application validator instance" do
    assert_instance_of ::OpenEhr::Application::ADLValidator,@adl_validator
  end


  must "validating openEHR-EHR-CLUSTER.exam-nervous_system.v1 using File.open not raised" do
    assert_nothing_raised do
      adl_file = File.open("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-nervous_system.v1.adl")
      @adl_validator.run(adl_file)
    end
  end

  must "validating openEHR-EHR-CLUSTER.exam-nervous_system.v1 using File.read not raised" do
    assert_nothing_raised do
      adl_string = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-nervous_system.v1.adl")
      stringio = StringIO.new(adl_string)
      @adl_validator.run(stringio)
    end
  end
end
