require 'test/unit'
require 'set'
require 'rm'

include OpenEHR::RM::Data_Structures
include OpenEHR::RM::Data_Structures::Item_Structure

class RmDataStructureTest < Test::Unit::TestCase
  def setup
    name = OpenEHR::RM::Data_Types::Text::DV_Text.new('blood')
    uid = OpenEHR::RM::Support::Identification::UID_Based_ID.new('ehr::test-1')
    links = Set.new([uid])
    assert_nothing_raised(Exception){
      @data_structure = OpenEHR::RM::Data_Structures::Data_Structure.new(:archetype_node_id => 'test',
                                                                         :name => name,
                                                                         :links => links) }
  end

  def test_init
    assert_instance_of OpenEHR::RM::Data_Structures::Data_Structure, @data_structure
  end

  def test_data_structure
    assert_raise(NotImplementedError){@data_structure.as_hierarchy}
  end
end

class RmDataStructureItemStructureTest < Test::Unit::TestCase
  def setup
    assert_nothing_raised(Exception){
      
  end

  def test_init
  end
end
