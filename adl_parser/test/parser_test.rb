#require 'lib/parser.rb'
require 'lib/adl_parser.rb'
require 'test/unit'

class ADLParserTest < Test::Unit::TestCase
  def setup
    @parser = ::OpenEHR::ADL::Parser.new
  end

  def test_init
    assert_instance_of ::OpenEHR::ADL::Parser,@parser
  end

  def test_parse
    laboratory_request = File.read('test/adl/openEHR-EHR-ITEM_TREE.Laboratory_request.v1.adl')
    assert_nothing_raised do
      result = @parser.parse(laboratory_request, 'openEHR-EHR-ITEM_TREE.Laboratory_request.v1.adl')
      assert_instance_of OpenEHR::AM::Archetype::ARCHETYPE, result
      assert_instance_of OpenEHR::AM::Archetype::Archetype_Description::ARCHETYPE_DESCRIPTION, result.description
      assert_instance_of OpenEHR::AM::Archetype::Constraint_Model::C_COMPLEX_OBJECT, result.definition
#      assert_equal '', result.definition
    end

    apgar = File.read('test/adl/openEHR-EHR-OBSERVATION.apgar.v1.adl')
    assert_nothing_raised do
      result = @parser.parse(apgar, 'openEHR-EHR-OBSERVATION.apgar.v1.adl')
      assert_instance_of OpenEHR::AM::Archetype::ARCHETYPE, result
      assert_instance_of OpenEHR::AM::Archetype::Archetype_Description::ARCHETYPE_DESCRIPTION, result.description
      assert_instance_of OpenEHR::AM::Archetype::Constraint_Model::C_COMPLEX_OBJECT, result.definition
    end

    evaluation = File.read('test/adl/openEHR-EHR-EVALUATION.adverse.v1.adl')
    assert_nothing_raised do
      @parser.parse(evaluation, 'openEHR-EHR-EVALUATION.adverse.v1.adl')
    end



    referral = File.read('test/adl/openEHR-EHR-ITEM_TREE.referral.v1.adl')
    assert_nothing_raised do
      @parser.parse(referral, 'openEHR-EHR-ITEM_TREE.referral.v1.adl')
    end

    exam_fetus = File.read('test/adl/openEHR-EHR-CLUSTER.exam-fetus.v1.adl')
    assert_nothing_raised do
      @parser.parse(exam_fetus, 'openEHR-EHR-CLUSTER.exam-fetus.v1.adl')
    end

    exam_uterine_cervix = File.read('test/adl/openEHR-EHR-CLUSTER.exam-uterine_cervix.v1.adl')
    assert_nothing_raised do
      @parser.parse(exam_uterine_cervix, 'openEHR-EHR-CLUSTER.exam-uterine_cervix.v1.adl')
    end

    imaging = File.read('test/adl/openEHR-EHR-ACTION.imaging.v1.adl')
    assert_nothing_raised do
      @parser.parse(imaging, 'openEHR-EHR-ACTION.imaging.v1.adl')
    end

    exam_nervous_system = File.read('test/adl/openEHR-EHR-CLUSTER.exam-nervous_system.v1.adl')
    assert_nothing_raised do
      @parser.parse(exam_nervous_system, 'openEHR-EHR-CLUSTER.exam-nervous_system.v1.adl')
    end
    exam_generic = File.read('test/adl/openEHR-EHR-CLUSTER.exam-generic.v1.adl')
    assert_nothing_raised do
      @parser.parse(exam_generic, 'openEHR-EHR-CLUSTER.exam-generic.v1.adl')
    end
    exam_generic_mass = File.read('test/adl/openEHR-EHR-CLUSTER.exam-generic-mass.v1.adl')
    assert_nothing_raised do
      @parser.parse(exam_generic_mass, 'openEHR-EHR-CLUSTER.exam-generic-mass.v1.adl')
    end
    exam_generic_lymphnode = File.read('test/adl/openEHR-EHR-CLUSTER.exam-generic-lymphnode.v1.adl')
    assert_nothing_raised do
      @parser.parse(exam_generic_lymphnode, 'openEHR-EHR-CLUSTER.exam-generic-lymphnode.v1.adl')
    end
    exam_generic_joint = File.read('test/adl/openEHR-EHR-CLUSTER.exam-generic-joint.v1.adl')
    assert_nothing_raised do
      @parser.parse(exam_generic_joint, 'openEHR-EHR-CLUSTER.exam-generic-joint.v1.adl')
    end
    exam_chest = File.read('test/adl/openEHR-EHR-CLUSTER.exam-chest.v1.adl')
    assert_nothing_raised do
      @parser.parse(exam_chest, 'openEHR-EHR-CLUSTER.exam-chest.v1.adl')
    end
    exam_abdomen = File.read('test/adl/openEHR-EHR-CLUSTER.exam-abdomen.v1.adl')
    assert_nothing_raised do
      @parser.parse(exam_abdomen, 'openEHR-EHR-CLUSTER.exam-abdomen.v1.adl')
    end
    cluster_auscultation = File.read('test/adl/openEHR-EHR-CLUSTER.auscultation.v1.adl')
    assert_nothing_raised do
      @parser.parse(cluster_auscultation, 'openEHR-EHR-CLUSTER.auscultation.v1.adl')
    end
    cluster_auscultation_chest = File.read('test/adl/openEHR-EHR-CLUSTER.auscultation-chest.v1.adl')
    assert_nothing_raised do
      @parser.parse(cluster_auscultation_chest, 'openEHR-EHR-CLUSTER.auscultation-chest.v1.adl')
    end
    vital_signs = File.read('test/adl/openEHR-EHR-SECTION.vital_signs.v1.adl')
    assert_nothing_raised do
      @parser.parse(vital_signs, 'openEHR-EHR-SECTION.vital_signs.v1')
    end
    summary = File.read('test/adl/openEHR-EHR-SECTION.summary.v1.adl')
    assert_nothing_raised do
      @parser.parse(summary, 'openEHR-EHR-SECTION.summary.v1.adl')
    end

    findings = File.read('test/adl/openEHR-EHR-SECTION.findings.v1.adl')
    assert_nothing_raised do
      @parser.parse(findings, 'openEHR-EHR-SECTION.findings.v1.adl')
    end

    reason_for_encounter = File.read('test/adl/openEHR-EHR-SECTION.reason_for_encounter.v1.adl')
    assert_nothing_raised do
      @parser.parse(reason_for_encounter, 'openEHR-EHR-SECTION.reason_for_encounter.v1.adl')
    end

    imaging = File.read('test/adl/openEHR-EHR-ITEM_TREE.imaging.v1.adl')
    assert_nothing_raised do
      @parser.parse(imaging, 'openEHR-EHR-ITEM_TREE.imaging.v1.adl')
    end
    instruction_referral = File.read('test/adl/openEHR-EHR-INSTRUCTION.referral.v1.adl')
    assert_nothing_raised do
      @parser.parse(instruction_referral, 'openEHR-EHR-INSTRUCTION.referral.v1.adl')
    end
    instruction_medication = File.read('test/adl/openEHR-EHR-INSTRUCTION.medication.v1.adl')
    assert_nothing_raised do
      @parser.parse(instruction_medication, 'openEHR-EHR-INSTRUCTION.medication.v1.adl')
    end
    action_referral = File.read('test/adl/openEHR-EHR-ACTION.referral.v1.adl')
    assert_nothing_raised do
      @parser.parse(action_referral, 'openEHR-EHR-ACTION.referral.v1.adl')
    end

    dimensions_circumference = File.read('test/adl/openEHR-EHR-CLUSTER.dimensions.v1.adl')
    assert_nothing_raised do
      @parser.parse(dimensions_circumference, 'openEHR-EHR-CLUSTER.dimensions.v1.adl')
    end

    discharge = File.read('test/adl/openEHR-EHR-COMPOSITION.discharge.v1draft.adl')
    assert_nothing_raised do
      @parser.parse(discharge, 'openEHR-EHR-COMPOSITION.discharge.v1draft.adl')
    end

    encounter = File.read('test/adl/openEHR-EHR-COMPOSITION.encounter.v1draft.adl')
    assert_nothing_raised do
      @parser.parse(encounter, 'openEHR-EHR-COMPOSITION.encounter.v1draft.adl')
    end


#     medication = File.read('test/adl/openEHR-EHR-ITEM_TREE.medication.v1.adl')
#     assert_nothing_raised do
#       @parser.parse(medication, 'openEHR-EHR-ITEM_TREE.medication.v1.adl')
#     end
  end
end
