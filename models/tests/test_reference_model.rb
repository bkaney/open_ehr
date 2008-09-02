require 'test/unit'
require 'set'
require 'rm'

class ReferenceModelTest < Test::Unit::TestCase
  def setup
    @authored_resource = OpenEHR::RM::Common::Resource::AUTHORED_RESOURCE.new(:original_language => "ja",
                                                                              :translations => "en",
                                                                              :description => "test")
    @translation_details = OpenEHR::RM::Common::Resource::TRANSLATION_DETAILS.new(nil,nil,nil,nil,nil)
#    @openehr_definitions = OpenEHR::RM::Support::Definition::OpenEHR_Definitions.new
    @dv_boolean = OpenEHR::RM::Data_Types::Basic::DV_Boolean.new("TRUE")
    @dv_state = OpenEHR::RM::Data_Types::Basic::DV_State.new("code1",true)
    @dv_identifier = OpenEHR::RM::Data_Types::Basic::DV_Identifier.new("Ruby Hospital","0123456-0", "Information office", "personal id")
    @dv_uri = OpenEHR::RM::Data_Types::URI::DV_URI.new("http://www.openehr.jp/changeset/test?cmd=93#file0")
    @dv_ehr_uri = OpenEHR::RM::Data_Types::URI::DV_EHR_URI.new("ehr://1234567/87284370-2D4B-4e3d-A3F3-F303D2F4F34B@2005-08-02T04:30:00")
    @dv_text = OpenEHR::RM::Data_Types::Text::DV_Text.new("valid value")
    @dv_coded_text = OpenEHR::RM::Data_Types::Text::DV_Coded_Text.new("valid value", "AT1000")
    @dv_paragraph = OpenEHR::RM::Data_Types::Text::DV_Paragraph.new(Set.new(["test1", "test2"]))
    @term_mapping = OpenEHR::RM::Data_Types::Text::Term_Mapping.new('=',@dv_coded_text,"TEST")
#    @code_phrase = OpenEHR::RM::Data_Types::Text::Code_Phrase.new
#    @agent = OpenEHR::RM::Demogrphic::Agent.new
#    @organisation = OpenEHR::RM::Demogrphic::Organisation.new
#    @person = OpenEHR::RM::Demogrphic::Person.new
#    @group = OpenEHR::RM::Demogrphic::Group.new
  end
  
  def test_init
    assert_instance_of OpenEHR::RM::Common::Resource::AUTHORED_RESOURCE, @authored_resource
    assert_instance_of OpenEHR::RM::Common::Resource::TRANSLATION_DETAILS, @translation_details
    assert_instance_of OpenEHR::RM::Data_Types::Basic::DV_Boolean, @dv_boolean
    assert_instance_of OpenEHR::RM::Data_Types::Basic::DV_State, @dv_state
    assert_instance_of OpenEHR::RM::Data_Types::Basic::DV_Identifier, @dv_identifier
    assert_instance_of OpenEHR::RM::Data_Types::URI::DV_URI, @dv_uri
    assert_instance_of OpenEHR::RM::Data_Types::URI::DV_EHR_URI, @dv_ehr_uri
    assert_instance_of OpenEHR::RM::Data_Types::Text::DV_Text, @dv_text
    assert_instance_of OpenEHR::RM::Data_Types::Text::DV_Coded_Text, @dv_coded_text
    assert_instance_of OpenEHR::RM::Data_Types::Text::Term_Mapping, @term_mapping
#    assert_instance_of OpenEHR::RM::Demogrphic::Agent, @agent
#    assert_instance_of OpenEHR::RM::Demogrphic::Organisation, @organisation
#    assert_instance_of OpenEHR::RM::Demogrphic::Person, @person
#    assert_instance_of OpenEHR::RM::Demogrphic::Group, @group
  end

  def test_constant
    assert_equal("\r", OpenEHR::RM::Support::Definition::OpenEHR_Definitions::CR)
    assert_equal("\n", OpenEHR::RM::Support::Definition::OpenEHR_Definitions::LF)
    assert_equal("\r", OpenEHR::RM::Data_Types::Basic::Data_Value::CR)
    assert_equal("\n", OpenEHR::RM::Data_Types::Basic::Data_Value::LF)
  end

  def test_dv_boolean
    assert @dv_boolean.value?
    @dv_boolean.value = false
    assert !@dv_boolean.value?
    # Constraints Value_exists
    assert_raise(ArgumentError){@dv_boolean.value=nil}
    assert_raise(ArgumentError){OpenEHR::RM::Data_Types::Basic::DV_Boolean.new(nil)}
  end

  def test_dv_state
    assert_equal("code1", @dv_state.value)
    assert_nothing_raised(Exception){@dv_state.value = "code2"}
    assert_equal("code2", @dv_state.value)
    assert @dv_state.is_terminal?
    assert_nothing_raised(Exception){@dv_state.is_terminal = false}
    assert !@dv_state.is_terminal?
    assert_raise(ArgumentError) {OpenEHR::RM::Data_Types::Basic::DV_State.new(nil,nil)}
    assert_raise(ArgumentError) {@dv_state.value=nil}
    assert_raise(ArgumentError) {@dv_state.is_terminal=nil}
  end

  def test_dv_identifier
    assert_equal("Ruby Hospital", @dv_identifier.assigner)
    assert_equal("0123456-0", @dv_identifier.id)
    assert_equal("Information office", @dv_identifier.issuer)
    assert_equal("personal id", @dv_identifier.type)
    @dv_identifier.assigner = "Test Hospital"
    assert_equal("Test Hospital", @dv_identifier.assigner)
    @dv_identifier.id = "TEST-0987"
    assert_equal("TEST-0987", @dv_identifier.id)
    @dv_identifier.issuer = "Security office"
    assert_equal("Security office", @dv_identifier.issuer)
    @dv_identifier.type = "test id"
    assert_equal("test id", @dv_identifier.type)
    assert_raise(ArgumentError) {OpenEHR::RM::Data_Types::Basic::DV_Identifier.new(nil, nil, nil, nil)}
  end

  def test_dv_uri
    assert_equal("file0", @dv_uri.fragment_id)
    assert_equal("/changeset/test", @dv_uri.path)
    assert_equal("cmd=93", @dv_uri.query)
    assert_equal("http", @dv_uri.scheme)
    assert_equal("http://www.openehr.jp/changeset/test?cmd=93#file0", @dv_uri.value)
    @dv_uri.value="svn://www.openehr.jp/openehr-jp/"
    assert_equal("svn://www.openehr.jp/openehr-jp/", @dv_uri.value)
    assert_equal("/openehr-jp/", @dv_uri.path)
  end

  def test_dv_ehr_uri
    assert_equal("ehr", @dv_ehr_uri.scheme)
    assert_raise(ArgumentError){
      @dv_ehr_uri.value="svn://www.openehr.jp/openehr-jp/" }
  end

  def test_dv_text
    assert_equal("valid value", @dv_text.value)
    assert_raise(ArgumentError){@dv_text.value = "not valid value\n"}
    assert_raise(ArgumentError){@dv_text.value = nil }
    assert_raise(ArgumentError){@dv_text.value = "" }
    assert_raise(ArgumentError){@dv_text.formatting = "" }
    assert_raise(ArgumentError){@dv_text.encoding = ""}
    assert_raise(ArgumentError){@dv_text.language = ""}
    assert_raise(ArgumentError){@dv_text.mappings = Set.new}
    assert_raise(ArgumentError){@dv_text.mappings = ""}
    assert_raise(ArgumentError){@dv_text.language = ""}
  end

  def test_dv_coded_text
    assert_equal("valid value", @dv_coded_text.value)
    assert_equal("AT1000", @dv_coded_text.defining_code)
    assert_raise(ArgumentError){@dv_coded_text.defining_code=nil}
  end

  def test_dv_paragraph
    assert_equal((Set.new ["test1", "test2"]), @dv_paragraph.items)
    assert_raise(ArgumentError){@dv_paragraph.items=Set.new}
  end

  def test_term_mapping
    assert_equal '=', @term_mapping.match
    assert OpenEHR::RM::Data_Types::Text::Term_Mapping.is_valid_mach_code?('>')
    assert OpenEHR::RM::Data_Types::Text::Term_Mapping.is_valid_mach_code?('=')
    assert OpenEHR::RM::Data_Types::Text::Term_Mapping.is_valid_mach_code?('<')
    assert OpenEHR::RM::Data_Types::Text::Term_Mapping.is_valid_mach_code?('?')
    assert !OpenEHR::RM::Data_Types::Text::Term_Mapping.is_valid_mach_code?('!')
    assert_equal @dv_coded_text, @term_mapping.purpose
    assert_equal "TEST", @term_mapping.target
    assert_raise(ArgumentError){OpenEHR::RM::Data_Types::Text::Term_Mapping.new}
    assert_raise(ArgumentError){OpenEHR::RM::Data_Types::Text::Term_Mapping.new('!',@dv_coded_text, "invalid case")}
    assert_raise(ArgumentError){OpenEHR::RM::Data_Types::Text::Term_Mapping.new('=',nil , "invalid case")}
    assert_raise(ArgumentError){OpenEHR::RM::Data_Types::Text::Term_Mapping.new('=',@dv_coded_text, nil)}
  end
end

class RM_Support_Identification_Test < Test::Unit::TestCase
  def setup
    assert_nothing_raised(Exception){@object_id = OpenEHR::RM::Support::Identification::Object_ID.new("0.0.3")}
    assert_nothing_raised(Exception){@object_ref = OpenEHR::RM::Support::Identification::Object_Ref.new('local', 'ANY', @object_id)}
    assert_nothing_raised(Exception){@archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("0.0.5", "biochemistry result_cholesterol", "entry", "ehr_rm", "openehr","cholesterol","0.0.3")}
    assert_nothing_raised(Exception){@terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new("0.0.7", 'terminology','0.0.3')}
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
    assert_equal "0.0.7", @terminology_id.value
    assert_nothing_raised(Exception){@terminology_id.value = "0.0.8"}
    assert_equal "0.0.8", @terminology_id.value
    assert_raise(ArgumentError){@terminology_id.value = nil}
    assert_raise(ArgumentError){@terminology_id.value = ""}

    assert_raise(ArgumentError){@terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new}
    assert_raise(ArgumentError){@terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new(nil, 'terminology','0.0.3')}
    assert_raise(ArgumentError){@terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new("", 'terminology','0.0.3')}
    assert_raise(ArgumentError){@terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new("", 'terminology','0.0.3')}
    assert_raise(ArgumentError){@terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new("0.0.7", nil,'0.0.3')}
    assert_raise(ArgumentError){@terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new("0.0.7", '','0.0.3')}
    assert_raise(ArgumentError){@terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new("0.0.7", "terminology", nil)}
    assert_nothing_raised(Exception){@terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new("0.0.7", "terminology",'')}

    assert_equal "terminology", @terminology_id.name
    assert_nothing_raised(Exception){@terminology_id.name = "snomed"}
    assert_equal "snomed", @terminology_id.name
    assert_raise(ArgumentError){@terminology_id.name = nil}
    assert_raise(ArgumentError){@terminology_id.name = ""}

    assert_equal "", @terminology_id.version_id
    assert_nothing_raised(Exception){@terminology_id.version_id = "0.0.8"}
    assert_equal "0.0.8", @terminology_id.version_id
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
# test constructorpp
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
