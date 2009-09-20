require File.dirname(__FILE__) + '/test_helper.rb'

class ADLParserTest < Test::Unit::TestCase
  def setup
    @parser = ::OpenEHR::ADL::Parser.new
  end

  must "assert parser instance" do
    assert_instance_of ::OpenEHR::ADL::Parser,@parser
  end

  must "test_archetype_id.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/test_archetype_id.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-SECTION.summary.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-ACTION.imaging.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-ACTION.imaging.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-ACTION.imaging.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-ACTION.referral.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-ACTION.referral.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-ACTION.referral.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-CLUSTER.auscultation-chest.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.auscultation-chest.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-CLUSTER.auscultation-chest.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-CLUSTER.auscultation.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.auscultation.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-CLUSTER.auscultation.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end


  must "openEHR-EHR-CLUSTER.exam-abdomen.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-abdomen.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-CLUSTER.exam-abdomen.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-CLUSTER.exam-chest.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-chest.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-CLUSTER.exam-chest.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-CLUSTER.exam-generic-joint.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-generic-joint.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-CLUSTER.exam-generic-joint.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-CLUSTER.exam-generic-lymphnode.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-generic-lymphnode.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-CLUSTER.exam-generic-lymphnode.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-CLUSTER.exam-generic-mass.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-generic-mass.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-CLUSTER.exam-generic-mass.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-CLUSTER.exam-generic.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-generic.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-CLUSTER.exam-generic.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-CLUSTER.exam-nervous_system.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-nervous_system.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-CLUSTER.exam-nervous_system.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-COMPOSITION.discharge.v1draft.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-COMPOSITION.discharge.v1draft.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-COMPOSITION.discharge.v1draft')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-COMPOSITION.encounter.v1draft.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-COMPOSITION.encounter.v1draft.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-COMPOSITION.encounter.v1draft')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-INSTRUCTION.medication.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-INSTRUCTION.medication.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-INSTRUCTION.medication.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-INSTRUCTION.referral.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-INSTRUCTION.referral.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-INSTRUCTION.referral.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-ITEM_TREE.Laboratory_request.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-ITEM_TREE.Laboratory_request.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-ITEM_TREE.Laboratory_request.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end


  must "openEHR-EHR-OBSERVATION.apgar.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-OBSERVATION.apgar.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-OBSERVATION.apgar.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-SECTION.findings.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-SECTION.findings.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-SECTION.findings.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end

  must "openEHR-EHR-SECTION.reason_for_encounter.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-SECTION.reason_for_encounter.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-SECTION.reason_for_encounter.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end


  must "openEHR-EHR-SECTION.vital_signs.v1.adl be properly parsed" do
    file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-SECTION.vital_signs.v1.adl")
    assert_nothing_raised do
      ast = @parser.parse(file, 'openEHR-EHR-SECTION.vital_signs.v1')
      assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
    end
  end


# C_DV_QUANTITY parse error
#   must "openEHR-EHR-CLUSTER.dimensions-circumference.v1.adl be properly parsed" do
#     file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.dimensions-circumference.v1.adl")
#     assert_nothing_raised do
#       ast = @parser.parse(file, 'openEHR-EHR-CLUSTER.dimensions-circumference.v1')
#       assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
#     end
#   end

#   must "openEHR-EHR-CLUSTER.dimensions.v1.adl be properly parsed" do
#     file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.dimensions.v1.adl")
#     assert_nothing_raised do
#       ast = @parser.parse(file, 'openEHR-EHR-CLUSTER.dimensions.v1')
#       assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
#     end
#   end

#   must "openEHR-EHR-CLUSTER.exam-fetus.v1.adl be properly parsed" do
#     file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-fetus.v1.adl")
#     assert_nothing_raised do
#       ast = @parser.parse(file, 'openEHR-EHR-CLUSTER.exam-fetus.v1')
#       assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
#     end
#   end

#   must "openEHR-EHR-CLUSTER.exam-uterine_cervix.v1.adl be properly parsed" do
#     file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-CLUSTER.exam-uterine_cervix.v1.adl")
#     assert_nothing_raised do
#       ast = @parser.parse(file, 'openEHR-EHR-CLUSTER.exam-uterine_cervix.v1')
#       assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
#     end
#   end

#   must "openEHR-EHR-EVALUATION.adverse.v1.adl be properly parsed" do
#     file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-EVALUATION.adverse.v1.adl")
#     assert_nothing_raised do
#       ast = @parser.parse(file, 'openEHR-EHR-EVALUATION.adverse.v1')
#       assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
#     end
#   end
#   must "openEHR-EHR-OBSERVATION.body_mass_index.v1.adl be properly parsed" do
#     file =  File.read("#{TEST_ROOT_DIR}/adl/openEHR-EHR-OBSERVATION.body_mass_index.v1.adl")
#     assert_nothing_raised do
#       ast = @parser.parse(file, 'openEHR-EHR-OBSERVATION.body_mass_index.v1')
#       assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, ast.archetype_id
#     end
#   end


end
