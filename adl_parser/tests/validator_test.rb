require 'adl_parser.rb'
require 'test/unit'

class ADLValidatorTest < Test::Unit::TestCase
  def setup
    @validator = ::OpenEHR::ADL::Validator.new(::OpenEHR::ADL::Parser.new)
  end

  def test_init
    assert_instance_of ::OpenEHR::ADL::Validator,@validator
  end

  def test_validate
    exam_nervous_system = File.read('tests/openEHR-EHR-CLUSTER.exam-nervous_system.v1.adl')
    assert_nothing_raised do
      @validator.validate(exam_nervous_system, 'openEHR-EHR-CLUSTER.exam-nervous_system.v1.adl')
    end

#     exam_uterine_cervix = File.read('tests/openEHR-EHR-CLUSTER.exam-uterine_cervix.v1.adl')
# #    assert_raise(Racc::ParseError) do
#    @validator.validate(exam_uterine_cervix, 'openEHR-EHR-CLUSTER.exam-uterine_cervix.v1.adl')
# #    end

  end
end
