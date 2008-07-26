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

  def test_terminology_mapping
    
  end
end


class ReferenceModelSupportIdentificationTest < Test::Unit::TestCase
  def setup
    @object_id = OpenEHR::RM::Support::Identification::OBJECT_ID.new
    @terminology_id = OpenEHR::RM::Support::Identification::TERMINOLOGY_ID.new('terminology','version')
    @archetype_id = OpenEHR::RM::Support::Identification::ARCHETYPE_ID.new
  end
  
  def test_init
    assert_instance_of OpenEHR::RM::Support::Identification::OBJECT_ID, @object_id
    assert_instance_of OpenEHR::RM::Support::Identification::TERMINOLOGY_ID, @terminology_id
    assert_instance_of OpenEHR::RM::Support::Identification::ARCHETYPE_ID, @archetype_id

  end
end
