require 'test/unit'
require 'set'
require 'rm'

include OpenEHR::RM::Data_Types::Text
include OpenEHR::RM::Common::Resource
include OpenEHR::RM::Common::Archetyped

class RM_Common_Resource_Test < Test::Unit::TestCase
  def setup
        @authored_resource = OpenEHR::RM::Common::Resource::AUTHORED_RESOURCE.new(:original_language => "ja",
                                                                              :translations => "en",
                                                                              :description => "test")
    @translation_details = OpenEHR::RM::Common::Resource::TRANSLATION_DETAILS.new(nil,nil,nil,nil,nil)
  end
  def test_init
    assert_instance_of OpenEHR::RM::Common::Resource::AUTHORED_RESOURCE, @authored_resource
    assert_instance_of OpenEHR::RM::Common::Resource::TRANSLATION_DETAILS, @translation_details
  end

  def test_authoured_resource
    assert_equal 'ja', @authored_resource.original_language
  end
end

class RM_Common_Archetyped_Test < Test::Unit::TestCase
  def setup
    @dv_text = OpenEHR::RM::Data_Types::Text::DV_Text.new('Test')
    @uid_based_id = OpenEHR::RM::Support::Identification::UID_Based_ID.new('rrip::0.0.5')
    @archetype_id = OpenEHR::RM::Support::Identification::Archetype_ID.new("0.0.5", "biochemistry result_cholesterol", "entry", "ehr_rm", "openehr","cholesterol","0.0.3")
    @template_id = OpenEHR::RM::Support::Identification::Template_ID.new('1.0.1')
    assert_nothing_raised(Exception){@archetyped = OpenEHR::RM::Common::Archetyped::Archetyped.new(@archetype_id, '1.0.1')}
    assert_nothing_raised(Exception){@link = OpenEHR::RM::Common::Archetyped::Link.new(OpenEHR::RM::Data_Types::Text::DV_Text.new("generic"), OpenEHR::RM::Data_Types::URI::DV_EHR_URI.new("ehr://test/"),OpenEHR::RM::Data_Types::Text::DV_Text.new("problem"))}
    assert_nothing_raised(Exception){
      @pathable = OpenEHR::RM::Common::Archetyped::Pathable.new }
    name = OpenEHR::RM::Data_Types::Text::DV_Text.new('blood')
    links = Set.new([@uid_based_id])
    assert_nothing_raised(Exception){
      @locatable = OpenEHR::RM::Common::Archetyped::Locatable.new('at0001',name,links)}
    assert_nothing_raised(Exception){
      @feeder_audit_details = Feeder_Audit_Details.new(:system_id => 'MAGI')}
  end

  def test_init
    assert_instance_of OpenEHR::RM::Common::Archetyped::Archetyped, @archetyped
    assert_instance_of OpenEHR::RM::Common::Archetyped::Link, @link
    assert_instance_of OpenEHR::RM::Common::Archetyped::Pathable, @pathable
    assert_instance_of OpenEHR::RM::Common::Archetyped::Locatable, @locatable
    assert_instance_of Feeder_Audit_Details, @feeder_audit_details
  end

  def test_archetyped
    assert_equal @archetype_id, @archetyped.archetype_id
    assert_equal '1.0.1', @archetyped.rm_version
    assert_raise(ArgumentError){@archetyped.archetype_id = nil}
    assert_raise(ArgumentError){@archetyped.rm_version = nil}
    assert_raise(ArgumentError){@archetyped.rm_version = ''}
    assert_nothing_raised(Exception){@archetyped.template_id = @template_id}
    assert_equal @template_id, @archetyped.template_id
    archetype_id2 = OpenEHR::RM::Support::Identification::Archetype_ID.new("1.0.2", "biochemistry result_cholesterol", "entry", "ehr_rm", "openehr","cholesterol","0.0.3")
    assert_nothing_raised(ArgumentError){@archetyped.archetype_id = archetype_id2}
    assert_equal archetype_id2, @archetyped.archetype_id
    assert_nothing_raised(ArgumentError){@archetyped.rm_version = '1.0.2'}
    assert_equal '1.0.2', @archetyped.rm_version
  end

  def test_link
    # test constructor
    assert_equal 'generic', @link.meaning.value
    assert_equal 'ehr://test/', @link.target.value
    assert_equal 'problem', @link.type.value
    # test meaning
    assert_nothing_raised(Exception){@link.meaning = OpenEHR::RM::Data_Types::Text::DV_Text.new('clinical')}
    assert_equal 'clinical', @link.meaning.value
    assert_raise(ArgumentError){@link.meaning = nil}
    # test target
    assert_nothing_raised(Exception){@link.target = OpenEHR::RM::Data_Types::URI::DV_EHR_URI.new("ehr://try/")}
    assert_equal 'ehr://try/', @link.target.value
    assert_raise(ArgumentError){@link.target = nil}
    # test type
    assert_nothing_raised(Exception){@link.type = OpenEHR::RM::Data_Types::Text::DV_Text.new("issue")}
    assert_equal 'issue', @link.type.value
    assert_raise(ArgumentError){@link.type = nil}
  end

  def test_feeder_audit
  end

  def test_feeder_audit_detail
    assert_equal 'MAGI', @feeder_audit_details.system_id
  end
end

class RM_Common_Generic_Test < Test::Unit::TestCase
  include OpenEHR::RM::Common::Generic
  include OpenEHR::RM::Support::Identification
  include OpenEHR::RM::Data_Types::Basic
  def setup
    assert_nothing_raised(Exception){party_proxy = Party_Proxy.new}
    object_id = Object_ID.new('0.0.4')
    party_ref = Party_Ref.new('unknown', 'ORGANISATION', object_id)
    assert_nothing_raised(Exception){
      @party_proxy = Party_Proxy.new(:external_ref => party_ref)}
    assert_nothing_raised(Exception){party_self = Party_Self.new}
    assert_nothing_raised(Exception){
      @party_self = Party_Self.new(:external_ref => party_ref)}
    assert_raise(ArgumentError){
      party_identified = Party_Identified.new}
    identifiers = []
    identifiers << DV_Identifier.new('NERV', 'MELCHIOR', 'GENDO', 'COMPUTER')
    identifiers << DV_Identifier.new('NERV', 'CASPER', 'GENDO', 'COMPUTER')
    identifiers << DV_Identifier.new('NERV', 'BALTHAZAR', 'GENDO', 'COMPUTER')
    assert_nothing_raised(Exception){
      @party_identified = Party_Identified.new(:name => 'NERV',
                                               :external_ref => party_ref,
                                               :identifier => identifiers)}
#    change_type = OpenEHR::RM::Data_Types::Text::DV_Text.new('audit_type')
#    time_committed = OpenEHR::RM::Data_Types::Quantity::Date_Time::DV_Date_Time.new(2008)
#    assert_nothing_raised(Exception){@audit_details = OpenEHR::RM::Common::Generic::Audit_Details.new('rails',@party_proxy, change_type, time_committed)}
  end

  def test_init
    assert_instance_of Party_Proxy, @party_proxy
    assert_instance_of Party_Self, @party_self
    assert_instance_of Party_Identified, @party_identified
  end

  def test_party_proxy
    assert_equal 'unknown', @party_proxy.external_ref.namespace
  end

  def test_party_self
    assert_equal 'ORGANISATION', @party_self.external_ref.type
  end

  def test_party_identified
    assert_equal 'NERV', @party_identified.name
    assert_equal '0.0.4', @party_identified.external_ref.id.value
    identifiers = @party_identified.identifier
    ids = [ ]
    identifiers.each do |id|
      ids << id.id
    end
    assert_equal %w[MELCHIOR CASPER BALTHAZAR], ids
  end
end

class RM_Common_Directory_Test < Test::Unit::TestCase
  def setup
    dv_text = OpenEHR::RM::Data_Types::Text::DV_Text.new('root')
    assert_nothing_raised(Exception){@folder = OpenEHR::RM::Common::Directory::Folder.new('at0000', dv_text, nil)}
  end
  
  def test_init
    assert_instance_of OpenEHR::RM::Common::Directory::Folder, @folder
  end

  def test_folder
    assert_equal 'at0000', @folder.archetype_node_id
    assert_equal 'root', @folder.name.value
  end
end

class RM_Common_Change_Control_Test < Test::Unit::TestCase
  def setup
    hier_object_id = OpenEHR::RM::Support::Identification::Hier_Object_ID.new('0.0.4')
    object_id = OpenEHR::RM::Support::Identification::Object_ID.new("0.0.3")
    object_ref = OpenEHR::RM::Support::Identification::Object_Ref.new('local', 'ANY', object_id)
    versions = Set.new [object_ref]
#    audit_detail = OpenEHR::RM::Generic::Audit_Detail.new()
#    assert_nothing_raised(Exception){@version = OpenEHR::RM::Common::Change_Control::Version.new(hier_object_id, versions)}
#    assert_nothing_raised(Exception){@contribution = OpenEHR::RM::Common::Change_Control::Contribution.new(hier_object_id, versions, audit_detail)}
  end
  def test_init
#    assert_instace_of OpenEHR::RM::Common::Change_Control::Contribution @contribution
#    assert_instace_of OpenEHR::RM::Common::Change_Control::Version @version
  end
  def test_version
  end
  def test_contribution
#    assert_equal @contribution.uid
  end
end
