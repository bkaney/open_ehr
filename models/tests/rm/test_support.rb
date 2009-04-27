require 'test/unit'
require 'set'
require 'rm'

class RM_Support_Definition_Test < Test::Unit::TestCase
    def test_constant
    assert_equal("\r", OpenEHR::RM::Support::Definition::OpenEHR_Definitions::CR)
    assert_equal("\n", OpenEHR::RM::Support::Definition::OpenEHR_Definitions::LF)
  end
end


class RM_Support_Identification_Test < Test::Unit::TestCase
  def setup
    assert_nothing_raised(Exception){@object_id = OpenEHR::RM::Support::Identification::Object_ID.new("0.0.3")}
    assert_nothing_raised(Exception){@object_ref = OpenEHR::RM::Support::Identification::Object_Ref.new('local', 'ANY', @object_id)}
    assert_nothing_raised(Exception){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("0.0.5", "biochemistry result_cholesterol", "entry", "ehr_rm", "openehr","cholesterol","0.0.3")}
    assert_nothing_raised(Exception){@terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new("ICD10",'2003')}
    assert_nothing_raised(Exception){@generic_id = OpenEHR::RM::Support::Identification::Generic_ID.new("0.0.3", "openehr")}
    assert_nothing_raised(Exception){@uid_based_id = OpenEHR::RM::Support::Identification::UID_Based_ID.new('rrip::0.0.3')}
    assert_nothing_raised(Exception){@hier_object_id = OpenEHR::RM::Support::Identification::Hier_Object_ID.new('0.0.4')}
    assert_nothing_raised(Exception){@locatable_ref = OpenEHR::RM::Support::Identification::Locatable_Ref.new('unknown', 'PERSON', @uid_based_id, 'data/event[at0001, standing]')}
    assert_nothing_raised(Exception){@party_ref = OpenEHR::RM::Support::Identification::Party_Ref.new('unknown', 'ORGANISATION', @object_id)}
    assert_nothing_raised(Exception){@access_group_ref = OpenEHR::RM::Support::Identification::Access_Group_Ref.new('unknown', 'ACCESS_GROUP', @object_id)}
    assert_nothing_raised(Exception){@version_tree_id = OpenEHR::RM::Support::Identification::Version_Tree_ID.new('1.2.3')}
  end
  
  def test_init
    assert_instance_of OpenEHR::RM::Support::Identification::Object_ID, @object_id
    assert_instance_of OpenEHR::RM::Support::Identification::Object_Ref, @object_ref
    assert_instance_of OpenEHR::RM::Support::Identification::Archetype_ID, @archetype_id
    assert_instance_of OpenEHR::RM::Support::Identification::Terminology_ID, @terminology_id
    assert_instance_of OpenEHR::RM::Support::Identification::Object_ID, @object_id
    assert_instance_of OpenEHR::RM::Support::Identification::Generic_ID, @generic_id
    assert_instance_of OpenEHR::RM::Support::Identification::UID_Based_ID, @uid_based_id
    assert_instance_of OpenEHR::RM::Support::Identification::Hier_Object_ID, @hier_object_id
    assert_instance_of OpenEHR::RM::Support::Identification::Locatable_Ref, @locatable_ref
    assert_instance_of OpenEHR::RM::Support::Identification::Party_Ref, @party_ref
    assert_instance_of OpenEHR::RM::Support::Identification::Access_Group_Ref, @access_group_ref
    assert_instance_of OpenEHR::RM::Support::Identification::Version_Tree_ID, @version_tree_id
  end

  def test_object_id
    assert_equal "0.0.3", @object_id.value
    assert_nothing_raised(Exception){@object_id.value = "0.0.4"}
    assert_equal "0.0.4", @object_id.value
    assert_raise(ArgumentError){@object_id.value=nil}
    assert_raise(ArgumentError){@object_id.value=""}
    assert_raise(ArgumentError){@object_id = OpenEHR::RM::Support::Identification::Object_ID.new}
    assert_raise(ArgumentError){@object_id = OpenEHR::RM::Support::Identification::Object_ID.new(nil)}
    assert_raise(ArgumentError){@object_id = OpenEHR::RM::Support::Identification::Object_ID.new("")}
    assert_equal @object_id, OpenEHR::RM::Support::Identification::Object_ID.new("0.0.4")
  end

  def test_object_refs
    assert_equal 'local', @object_ref.namespace
    assert_equal 'ANY', @object_ref.type
    assert_equal @object_id, @object_ref.id

    assert_raise(ArgumentError){@object_ref = OpenEHR::RM::Support::Identification::Archetype_ID.new}
    assert_raise(ArgumentError){@object_ref = OpenEHR::RM::Support::Identification::Archetype_ID.new(nil, 'ANY', @object_id)}
    assert_raise(ArgumentError){@object_ref = OpenEHR::RM::Support::Identification::Archetype_ID.new('', 'ANY', @object_id)}
    assert_raise(ArgumentError){@object_ref = OpenEHR::RM::Support::Identification::Archetype_ID.new('local', nil, @object_id)}
    assert_raise(ArgumentError){@object_ref = OpenEHR::RM::Support::Identification::Archetype_ID.new('local', '', @object_id)}
    assert_raise(ArgumentError){@object_ref = OpenEHR::RM::Support::Identification::Archetype_ID.new('local', 'ANY', nil)}

    assert_nothing_raised(Exception){@object_ref.namespace = 'terminology'}
    assert_equal 'terminology', @object_ref.namespace
    assert_raise(ArgumentError){@object_ref.namespace = nil}
    assert_raise(ArgumentError){@object_ref.namespace = ''}
    assert_raise(ArgumentError){@object_ref.namespace = '?&&'}
    assert_raise(ArgumentError){@object_ref.namespace = '843'}

    assert_nothing_raised(Exception){@object_ref.type = 'GUIDELINE'}
    assert_equal 'GUIDELINE', @object_ref.type
    assert_raise(ArgumentError){@object_ref.type = nil}
    assert_raise(ArgumentError){@object_ref.type = ''}

    assert_nothing_raised(Exception){@object_ref.id = OpenEHR::RM::Support::Identification::Object_ID.new("0.0.5")}
    assert_equal OpenEHR::RM::Support::Identification::Object_ID.new("0.0.5"), @object_ref.id
    assert_raise(ArgumentError){@object_ref.id = nil}
  end

  def test_archetype_id
    assert_equal "0.0.5", @archetype_id.value
    assert_nothing_raised(Exception){@archetype_id.value = "0.0.6"}
    assert_equal "0.0.6", @archetype_id.value
    assert_raise(ArgumentError){@archetype_id.value=nil}
    assert_raise(ArgumentError){@archetype_id.value=""}
    assert_raise(ArgumentError){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new}
    assert_raise(ArgumentError){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new(nil, "biochemistry result_cholesterol", "entry", "ehr_rm", "openehr","cholesterol","0.0.3")}
    assert_raise(ArgumentError){@object_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("", "biochemistry result_cholesterol", "entry", "ehr_rm", "openehr","cholesterol","0.0.3")}
    assert_raise(ArgumentError){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("0.0.5", nil, "entry", "ehr_rm", "openehr","cholesterol","0.0.3")}
    assert_raise(ArgumentError){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("0.0.5", "", "entry", "ehr_rm", "openehr","cholesterol","0.0.3")}
    assert_raise(ArgumentError){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("0.0.5", "biochemistry result_cholesterol", nil, "ehr_rm", "openehr","cholesterol","0.0.3")}
    assert_raise(ArgumentError){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("0.0.5", "biochemistry result_cholesterol", "", "ehr_rm", "openehr","cholesterol","0.0.3")}
    assert_raise(ArgumentError){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("0.0.5", "biochemistry result_cholesterol", "entry", nil, "openehr","cholesterol","0.0.3")}
    assert_raise(ArgumentError){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("0.0.5", "biochemistry result_cholesterol", "entry", "", "openehr","cholesterol","0.0.3")}
    assert_raise(ArgumentError){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("0.0.5", "biochemistry result_cholesterol", "entry", "ehr_rm", nil,"cholesterol","0.0.3")}
    assert_raise(ArgumentError){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("0.0.5", "biochemistry result_cholesterol", "entry", "ehr_rm", "","cholesterol","0.0.3")}
    assert_raise(ArgumentError){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("0.0.5", "biochemistry result_cholesterol", "entry", "ehr_rm", "openehr",nil ,"0.0.3")}
    assert_raise(ArgumentError){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("0.0.5", "biochemistry result_cholesterol", "entry", "ehr_rm", "openehr","","0.0.3")}
    assert_raise(ArgumentError){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("0.0.5", "biochemistry result_cholesterol", "entry", "ehr_rm", "openehr","cholesterol", nil)}
    assert_raise(ArgumentError){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("0.0.5", "biochemistry result_cholesterol", "entry", "ehr_rm", "openehr","cholesterol","")}

    assert_equal "biochemistry result_cholesterol", @archetype_id.domain_concept
    assert_nothing_raised(Exception){(@archetype_id.domain_concept = "biochemistry result_triglyceride")}
    assert_equal "biochemistry result_triglyceride", @archetype_id.domain_concept
    assert_raise(ArgumentError){@archetype_id.domain_concept = nil}
    assert_raise(ArgumentError){@archetype_id.domain_concept = ""}

    assert_equal "entry", @archetype_id.rm_name
    assert_nothing_raised(Exception){@archetype_id.rm_name = "section"}
    assert_equal "section", @archetype_id.rm_name
    assert_raise(ArgumentError){@archetype_id.rm_name = nil}
    assert_raise(ArgumentError){@archetype_id.rm_name = ""}

    assert_equal "ehr_rm", @archetype_id.rm_entity
    assert_nothing_raised(Exception){@archetype_id.rm_entity = "13606"}
    assert_equal "13606", @archetype_id.rm_entity
    assert_raise(ArgumentError){@archetype_id.rm_entity = nil}
    assert_raise(ArgumentError){@archetype_id.rm_entity = ""}

    assert_equal "openehr", @archetype_id.rm_originator
    assert_nothing_raised(Exception){@archetype_id.rm_originator = "cen"}
    assert_equal "cen", @archetype_id.rm_originator
    assert_raise(ArgumentError){@archetype_id.rm_originator = nil}
    assert_raise(ArgumentError){@archetype_id.rm_originator = ""}

    assert_equal "cholesterol", @archetype_id.specialisation
    assert_nothing_raised(Exception){@archetype_id.specialisation = "triglyceride"}
    assert_equal "triglyceride", @archetype_id.specialisation
    assert_raise(ArgumentError){@archetype_id.specialisation = nil}
    assert_raise(ArgumentError){@archetype_id.specialisation = ""}

    assert_equal "0.0.3", @archetype_id.version_id
    assert_nothing_raised(Exception){@archetype_id.version_id = "0.0.7"}
    assert_equal "0.0.7", @archetype_id.version_id
    assert_raise(ArgumentError){@archetype_id.version_id = nil}
    assert_raise(ArgumentError){@archetype_id.version_id = ""}
  end

  def test_terminology_id
    assert_equal "ICD10(2003)", @terminology_id.value
    assert_nothing_raised(Exception){@terminology_id.value = "ICD9(1999)"}
    assert_equal "ICD9", @terminology_id.name
    assert_equal "1999", @terminology_id.version_id
    assert_raise(ArgumentError){@terminology_id.value = nil}
    assert_raise(ArgumentError){@terminology_id.value = ""}

    assert_raise(ArgumentError){@terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new}
    assert_raise(ArgumentError){@terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new(nil,'2008')}
    assert_raise(ArgumentError){@terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new('','02008')}
    assert_raise(ArgumentError){@terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new("SNOMED", nil)}
    assert_nothing_raised(Exception){@terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new("SNOMED",'')}

    assert_equal "SNOMED", @terminology_id.name
    assert_nothing_raised(Exception){@terminology_id.name = "LOINC"}
    assert_equal "LOINC", @terminology_id.name
    assert_raise(ArgumentError){@terminology_id.name = nil}
    assert_raise(ArgumentError){@terminology_id.name = ""}

    assert_equal "", @terminology_id.version_id
    assert_nothing_raised(Exception){@terminology_id.version_id = "2008"}
    assert_equal "2008", @terminology_id.version_id
    assert_equal 'LOINC(2008)', @terminology_id.value
    assert_raise(ArgumentError){@terminology_id.version_id = nil}
    assert_nothing_raised(Exception){@terminology_id.version_id = ''}
  end

  def test_generic_id
    assert_equal "0.0.3", @generic_id.value
    assert_equal "openehr", @generic_id.scheme

    assert_raise(ArgumentError){@generic_id = OpenEHR::RM::Support::Identification::Generic_ID.new(nil, "openehr")}
    assert_raise(ArgumentError){@generic_id = OpenEHR::RM::Support::Identification::Generic_ID.new("", "openehr")}
    assert_raise(ArgumentError){@generic_id = OpenEHR::RM::Support::Identification::Generic_ID.new("0.0.3", nil)}
    assert_raise(ArgumentError){@generic_id = OpenEHR::RM::Support::Identification::Generic_ID.new("0.0.3", "")}

    assert_raise(ArgumentError){@generic_id.value = nil}
    assert_raise(ArgumentError){@generic_id.value = ""}
    assert_nothing_raised(Exception){@generic_id.value = "0.0.5"}
    assert_equal "0.0.5", @generic_id.value

    assert_raise(ArgumentError){@generic_id.scheme = nil}
    assert_raise(ArgumentError){@generic_id.scheme = ""}
    assert_nothing_raised(Exception){@generic_id.scheme = "cen"}
    assert_equal "cen", @generic_id.scheme
  end

  def test_uid_based_id
    assert_equal "rrip::0.0.3", @uid_based_id.value
    assert_equal "rrip", @uid_based_id.root
    assert_equal '0.0.3', @uid_based_id.extension
    assert @uid_based_id.has_extension?

    assert_raise(ArgumentError){@uid_based_id = OpenEHR::RM::Support::Identification::UID_Based_ID.new(nil)}
    assert_raise(ArgumentError){@uid_based_id = OpenEHR::RM::Support::Identification::UID_Based_ID.new('')}
    assert_raise(ArgumentError){@uid_based_id.value = nil}
    assert_raise(ArgumentError){@uid_based_id.value = ''}

    assert_nothing_raised(Exception){@uid_based_id.value = 'rrip'}
    assert_equal 'rrip', @uid_based_id.value
    assert_equal 'rrip', @uid_based_id.root
    assert_equal '', @uid_based_id.extension
  end

  def test_hier_object_id
    assert_equal '0.0.4', @hier_object_id.value
    assert !@hier_object_id.root.nil?
    assert !@hier_object_id.has_extension?
# in the specification 1.0.1 has_extension? xor extention != Void void is not nil?
    assert @hier_object_id.extension.empty?
    assert_nothing_raised(Exception){@hier_object_id.value = "ehr::test"}
    assert !@hier_object_id.root.nil?
    assert @hier_object_id.has_extension?
    assert !@hier_object_id.extension.empty?
  end

  def test_locatable_ref
# test constructor
    assert_equal 'unknown', @locatable_ref.namespace
    assert_equal 'PERSON', @locatable_ref.type
    assert_equal @uid_based_id, @locatable_ref.id
    assert_equal 'data/event[at0001, standing]', @locatable_ref.path
    assert_equal 'ehr://rrip::0.0.3/data/event[at0001, standing]', @locatable_ref.as_uri
#test path
    assert_nothing_raised(Exception){@locatable_ref.path = 'data/event[at0002, tilting]'}
    assert_equal 'data/event[at0002, tilting]', @locatable_ref.path
    assert_equal 'ehr://rrip::0.0.3/data/event[at0002, tilting]', @locatable_ref.as_uri
  end

  def test_party_ref
# test constructor
    assert_equal 'unknown', @party_ref.namespace
    assert_equal 'ORGANISATION', @party_ref.type
    assert_equal @object_id, @party_ref.id
# test type validation
    assert_raise(ArgumentError){@party_ref.type = 'GUIDELINE'}
    assert_nothing_raised(Exception){@party_ref.type = 'PERSON'}
    assert_equal 'PERSON', @party_ref.type
    assert_nothing_raised(Exception){@party_ref.type = 'GROUP'}
    assert_nothing_raised(Exception){@party_ref.type = 'AGENT'}
    assert_nothing_raised(Exception){@party_ref.type = 'ROLE'}
    assert_nothing_raised(Exception){@party_ref.type = 'PARTY'}
    assert_nothing_raised(Exception){@party_ref.type = 'ACTOR'}
  end

  def test_access_group_ref
# test constructor
    assert_equal 'unknown', @access_group_ref.namespace
    assert_equal 'ACCESS_GROUP', @access_group_ref.type
    assert_equal @object_id, @access_group_ref.id
# test type validation
    assert_raise(ArgumentError){@access_group_ref.type = 'PERSON'}
    assert_nothing_raised(Exception){@access_group_ref.type = 'ACCESS_GROUP'}
  end

  def test_version_tree_id
    assert_equal '1.2.3', @version_tree_id.value
    assert_equal '1', @version_tree_id.trunk_version
    assert_equal '2', @version_tree_id.branch_number
    assert_equal '3', @version_tree_id.branch_version
    assert @version_tree_id.is_first?
    assert @version_tree_id.is_branch?
    assert_nothing_raised(Exception){@version_tree_id.value = '2'}
    assert_equal '2', @version_tree_id.trunk_version
    assert !@version_tree_id.is_first?
    assert !@version_tree_id.is_branch?
    assert_nil @version_tree_id.branch_number
    assert_nil @version_tree_id.branch_version
    assert_raise(ArgumentError){@version_tree_id.branch_version = '5'}
  end
end
