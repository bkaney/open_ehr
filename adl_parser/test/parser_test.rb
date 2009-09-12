#require 'lib/adl_parser.rb'
require File.dirname(__FILE__) + '/test_helper.rb'

class ADLParserTest < Test::Unit::TestCase
  def setup
    @parser = ::OpenEHR::ADL::Parser.new
  end

  def test_init
    assert_instance_of ::OpenEHR::ADL::Parser,@parser
  end

  def test_parse
    body_mass_index =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-OBSERVATION.body_mass_index.v1.adl")
#    body_mass_index = File.read('test/adl/openEHR-EHR-OBSERVATION.body_mass_index.v1.adl')
    assert_nothing_raised do
      ast = @parser.parse(body_mass_index, 'openEHR-EHR-OBSERVATION.body_mass_index.v1.adl')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end

    laboratory_request = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-ITEM_TREE.Laboratory_request.v1.adl")
    assert_nothing_raised do
      result = @parser.parse(laboratory_request, 'openEHR-EHR-ITEM_TREE.Laboratory_request.v1')
      assert_instance_of OpenEHR::AM::Archetype::ARCHETYPE, result
      assert_instance_of OpenEHR::AM::Archetype::Archetype_Description::ARCHETYPE_DESCRIPTION, result.description
      assert_instance_of OpenEHR::AM::Archetype::Constraint_Model::C_COMPLEX_OBJECT, result.definition
    end

    apgar = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-OBSERVATION.apgar.v1.adl")
    assert_nothing_raised do
      result = @parser.parse(apgar, 'openEHR-EHR-OBSERVATION.apgar.v1')
      assert_instance_of OpenEHR::AM::Archetype::ARCHETYPE, result
      assert_instance_of OpenEHR::AM::Archetype::Archetype_Description::ARCHETYPE_DESCRIPTION, result.description
      assert_instance_of OpenEHR::AM::Archetype::Constraint_Model::C_COMPLEX_OBJECT, result.definition
    end

    evaluation = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-EVALUATION.adverse.v1.adl")
    assert_nothing_raised do
      @parser.parse(evaluation, 'openEHR-EHR-EVALUATION.adverse.v1')
    end

    referral = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-ITEM_TREE.referral.v1.adl")
    assert_nothing_raised do
      @parser.parse(referral, 'openEHR-EHR-ITEM_TREE.referral.v1')
    end

    exam_fetus = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-fetus.v1.adl")
    assert_nothing_raised do
      @parser.parse(exam_fetus, 'openEHR-EHR-CLUSTER.exam-fetus.v1')
    end

    exam_uterine_cervix = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-uterine_cervix.v1.adl")
    assert_nothing_raised do
      @parser.parse(exam_uterine_cervix, 'openEHR-EHR-CLUSTER.exam-uterine_cervix.v1')
    end

    imaging = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-ACTION.imaging.v1.adl")
    assert_nothing_raised do
      @parser.parse(imaging, 'openEHR-EHR-ACTION.imaging.v1')
    end

    exam_nervous_system = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-nervous_system.v1.adl")
    assert_nothing_raised do
      @parser.parse(exam_nervous_system, 'openEHR-EHR-CLUSTER.exam-nervous_system.v1')
    end

    exam_generic = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-generic.v1.adl")
    assert_nothing_raised do
      @parser.parse(exam_generic, 'openEHR-EHR-CLUSTER.exam-generic.v1')
    end

    exam_generic_mass = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-generic-mass.v1.adl")
    assert_nothing_raised do
      @parser.parse(exam_generic_mass, 'openEHR-EHR-CLUSTER.exam-generic-mass.v1')
    end

#     exam_generic_lymphnode = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-generic-lymphnode.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(exam_generic_lymphnode, 'openEHR-EHR-CLUSTER.exam-generic-lymphnode.v1')
#     end

#     exam_generic_joint = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-generic-joint.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(exam_generic_joint, 'openEHR-EHR-CLUSTER.exam-generic-joint.v1')
#     end

#     exam_chest = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-chest.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(exam_chest, 'openEHR-EHR-CLUSTER.exam-chest.v1')
#     end

#     exam_abdomen = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-abdomen.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(exam_abdomen, 'openEHR-EHR-CLUSTER.exam-abdomen.v1')
#     end

#     cluster_auscultation = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.auscultation.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(cluster_auscultation, 'openEHR-EHR-CLUSTER.auscultation.v1')
#     end

#     cluster_auscultation_chest = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.auscultation-chest.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(cluster_auscultation_chest, 'openEHR-EHR-CLUSTER.auscultation-chest.v1')
#     end

#     vital_signs = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-SECTION.vital_signs.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(vital_signs, 'openEHR-EHR-SECTION.vital_signs.v1')
#     end

#     summary = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-SECTION.summary.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(summary, 'openEHR-EHR-SECTION.summary.v1')
#     end

#     findings = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-SECTION.findings.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(findings, 'openEHR-EHR-SECTION.findings.v1')
#     end

#     reason_for_encounter = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-SECTION.reason_for_encounter.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(reason_for_encounter, 'openEHR-EHR-SECTION.reason_for_encounter.v1')
#     end

#     imaging = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-ITEM_TREE.imaging.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(imaging, 'openEHR-EHR-ITEM_TREE.imaging.v1')
#     end

#     instruction_referral = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-INSTRUCTION.referral.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(instruction_referral, 'openEHR-EHR-INSTRUCTION.referral.v1')
#     end

#     instruction_medication = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-INSTRUCTION.medication.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(instruction_medication, 'openEHR-EHR-INSTRUCTION.medication.v1')
#     end

#     action_referral = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-ACTION.referral.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(action_referral, 'openEHR-EHR-ACTION.referral.v1')
#     end

#     dimensions_circumference = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.dimensions.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(dimensions_circumference, 'openEHR-EHR-CLUSTER.dimensions.v1')
#     end

#     discharge = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-COMPOSITION.discharge.v1draft.adl")
#     assert_nothing_raised do
#       @parser.parse(discharge, 'openEHR-EHR-COMPOSITION.discharge.v1draft')
#     end

#     encounter = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-COMPOSITION.encounter.v1draft.adl")
#     assert_nothing_raised do
#       @parser.parse(encounter, 'openEHR-EHR-COMPOSITION.encounter.v1draft')
#     end


#     medication = File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-ITEM_TREE.medication.v1.adl")
#     assert_nothing_raised do
#       @parser.parse(medication, 'openEHR-EHR-ITEM_TREE.medication.v1.adl")
#     end
  end
end
