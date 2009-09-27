require File.dirname(__FILE__) + '/test_helper.rb'


class ADLValidatorTest < Test::Unit::TestCase
  def setup
    @validator = ::OpenEhr::ADL::Validator.new(::OpenEhr::ADL::Parser.new)
  end

  must "assert adl validator instance" do
    assert_instance_of ::OpenEhr::ADL::Validator,@validator
  end

  must "assert validation openEHR-EHR-CLUSTER.exam-nervous_system.v1" do
    exam_nervous_system = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-nervous_system.v1.adl")
    assert_nothing_raised do
      @validator.validate(exam_nervous_system, 'openEHR-EHR-CLUSTER.exam-nervous_system.v1')
    end
  end
#     exam_uterine_cervix = File.read('tests/openEHR-EHR-CLUSTER.exam-uterine_cervix.v1.adl')
# #    assert_raise(Racc::ParseError) do
#    @validator.validate(exam_uterine_cervix, 'openEHR-EHR-CLUSTER.exam-uterine_cervix.v1.adl')
# #    end
end
