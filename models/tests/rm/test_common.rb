require 'test/unit'
require 'set'
require 'rm'

include OpenEHR::RM::Data_Types::Text
include OpenEHR::RM::Common::Resource
include OpenEHR::RM::Common::Archetyped
include OpenEHR::RM::Common::Generic
include OpenEHR::RM::Common::Change_Control
include OpenEHR::RM::Support::Identification
include OpenEHR::RM::Data_Types::Basic
include OpenEHR::RM::Data_Types::Quantity
include OpenEHR::RM::Data_Types::URI

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
    provider = Party_Identified.new(:name => 'NERV')
    location = Party_Identified.new(:name => 'GEOFRONT')
    object_version_id = Object_Version_ID.new('ABC::DEF::1.3.4')
    party_ref = Party_Ref.new('local', 'ORGANISATION', object_id)
    assert_nothing_raised(Exception){
      @feeder_audit_details = Feeder_Audit_Details.new(:system_id => 'MAGI',
                                                       :provider => provider,
                                                       :location => location,
                                                       :time => DV_Date_Time.new('2009-07-03T12:16:31'),
                                                       :subject => Party_Proxy.new(:external_ref => party_ref),
                                                       :version_id => '0.0.4')}
    feeder_audit_details = Feeder_Audit_Details.new(:system_id => 'AKAGI')
    dv_identifier = DV_Identifier.new('NERV', 'MELCHIOR', 'RITSUKO', 'COMPUTER')
    feeder_audit_details2 = Feeder_Audit_Details.new(:system_id => 'KATSURAGI')
    dv_identifier2 = DV_Identifier.new('NERV', 'SHOGOUKI', 'MISATO', 'EVANGELION')
    charset = OpenEHR::RM::Data_Types::Text::Code_Phrase.new('UTF-8','character-sets')
    language = OpenEHR::RM::Data_Types::Text::Code_Phrase.new('ja', 'languages')

    dv_encapsulated = OpenEHR::RM::Data_Types::Encapsulated::DV_Encapsulated.new(charset, language, 10)
    assert_nothing_raised(Exception){
      @feeder_audit = Feeder_Audit.new(:originating_system_audit => feeder_audit_details,
                                       :originating_system_item_ids => [dv_identifier],
                                       :feeder_system_audit => feeder_audit_details2,
                                       :feeder_system_item_ids => [dv_identifier2],
                                       :original_content => dv_encapsulated)}
  end

  def test_init
    assert_instance_of OpenEHR::RM::Common::Archetyped::Archetyped, @archetyped
    assert_instance_of OpenEHR::RM::Common::Archetyped::Link, @link
    assert_instance_of OpenEHR::RM::Common::Archetyped::Pathable, @pathable
    assert_instance_of OpenEHR::RM::Common::Archetyped::Locatable, @locatable
    assert_instance_of Feeder_Audit_Details, @feeder_audit_details
    assert_instance_of Feeder_Audit, @feeder_audit
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
    assert_equal 'AKAGI', @feeder_audit.originating_system_audit.system_id
    assert_equal 'RITSUKO', @feeder_audit.originating_system_item_ids[0].issuer
    assert_equal 'KATSURAGI', @feeder_audit.feeder_system_audit.system_id
    assert_equal 'MISATO', @feeder_audit.feeder_system_item_ids[0].issuer
    assert_equal 'UTF-8', @feeder_audit.original_content.charset.code_string
  end

  def test_feeder_audit_detail
    assert_equal 'MAGI', @feeder_audit_details.system_id
    assert_equal 'NERV', @feeder_audit_details.provider.name
    assert_equal 'GEOFRONT', @feeder_audit_details.location.name
    assert_equal 2009, @feeder_audit_details.time.year
    assert_equal 'local', @feeder_audit_details.subject.external_ref.namespace
    assert_equal '0.0.4', @feeder_audit_details.version_id
  end
end

class RM_Common_Generic_Test < Test::Unit::TestCase
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

    terminology_id = Terminology_ID.new('test(0.04)')
    code_phrase = Code_Phrase.new('self', terminology_id)
    dv_coded_text = DV_Coded_Text.new('Seele',code_phrase)
    assert_nothing_raised(Exception){
      @party_related = Party_Related.new(:name => 'GEHIRN',
                                         :relationship => dv_coded_text)}
    dv_text = DV_Text.new('commiter')
    dv_coded_text = DV_Coded_Text.new('present',terminology_id)
    dv_date_time1 = DV_Date_Time.new('2009-07-04T16:30:00')
    dv_date_time2 = DV_Date_Time.new('2009-07-14T00:00:00')
    dv_interval = DV_Interval.new(dv_date_time1, dv_date_time2)
    assert_nothing_raised(Exception){
      @participation = Participation.new(:performer => @party_proxy,
                                         :function => dv_text,
                                         :mode => dv_coded_text,
                                         :time => dv_interval)}
    dv_date_time = DV_Date_Time.new('2009-07-04T18:56:00')
    terminology_id = Terminology_ID.new('openehr(1.0.2)')
    code_phrase = Code_Phrase.new('249', terminology_id)
    dv_coded_text = DV_Coded_Text.new('creation', code_phrase)
    dv_text = DV_Text.new('test environment')
    assert_nothing_raised(Exception){
      @audit_details = Audit_Details.new(:system_id => 'MAGI',
                                         :committer => @party_proxy,
                                         :time_committed => dv_date_time,
                                         :change_type => dv_coded_text,
                                         :description => dv_text)}
    dv_text = DV_Text.new('authorisation')
    dv_ehr_uri = DV_EHR_URI.new('ehr://test/')
    assert_nothing_raised(Exception){
      @attestation = Attestation.new(:system_id => 'NERV',
                                     :committer => @party_proxy,
                                     :time_committed => dv_date_time,
                                     :change_type => dv_coded_text,
                                     :reason => dv_text,
                                     :description => dv_text,
                                     :proof => 'hashedstring',
                                     :items => Set[dv_ehr_uri])}
    object_version_id = Object_Version_ID.new('SHOGOUKI::NERV::1.1.1')
    audit_details2 = Audit_Details.new(:system_id => 'MAGI',
                                       :committer => @party_proxy,
                                       :time_committed => dv_date_time2,
                                       :change_type => dv_coded_text)
    assert_nothing_raised(Exception){
      @revision_history_item = Revision_History_Item.new(:audits => [@audit_details, audit_details2],
                                                         :version_id => object_version_id)}
    dv_date_time3 = DV_Date_Time.new('2009-07-14T12:00:00')
    dv_date_time4 = DV_Date_Time.new('2009-07-15T00:00:00')
    audit_details3 = Audit_Details.new(:system_id => 'MAGI',
                                     :committer => @party_proxy,
                                     :time_committed => dv_date_time3,
                                     :change_type => dv_coded_text)
    audit_details4 = Audit_Details.new(:system_id => 'MAGI',
                                     :committer => @party_proxy,
                                     :time_committed => dv_date_time4,
                                     :change_type => dv_coded_text)
    object_version_id = Object_Version_ID.new('NIGOUKI::NERV::2.2.2')
    revision_history_item2 = Revision_History_Item.new(:audits => [audit_details3, audit_details4],
                                                      :version_id => object_version_id)
    assert_nothing_raised(Exception){
      @revision_history = Revision_History.new([@revision_history_item, revision_history_item2])}
  end

  def test_init
    assert_instance_of Party_Proxy, @party_proxy
    assert_instance_of Party_Self, @party_self
    assert_instance_of Party_Identified, @party_identified
    assert_instance_of Participation, @participation
    assert_instance_of Audit_Details, @audit_details
    assert_instance_of Attestation, @attestation
    assert_instance_of Revision_History_Item, @revision_history_item
    assert_instance_of Revision_History, @revision_history
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

  def test_party_related
    assert_equal 'GEHIRN', @party_related.name
  end

  def test_participation
    assert_equal 'unknown', @participation.performer.external_ref.namespace
    assert_equal 'commiter', @participation.function.value
    assert_equal 'present', @participation.mode.value
    assert_equal 2009, @participation.time.lower.year
  end

  def test_audit_details
    assert_equal 'MAGI', @audit_details.system_id
    assert_equal 'unknown', @audit_details.committer.external_ref.namespace
    assert_equal '2009-07-04T18:56:00', @audit_details.time_committed.as_string
    assert_equal 'creation', @audit_details.change_type.value
    assert_equal 'test environment', @audit_details.description.value
  end

  def test_attestation
    assert_equal 'NERV', @attestation.system_id
    assert_equal 'unknown', @attestation.committer.external_ref.namespace
    assert_equal '249', @attestation.change_type.defining_code.code_string
    assert_equal 7, @attestation.time_committed.month
    assert_equal 'authorisation', @attestation.reason.value
    assert_equal 'authorisation', @attestation.description.value
    assert_equal 'hashedstring', @attestation.proof
    assert_equal 'ehr://test/', @attestation.items.to_a[0].value
  end

  def test_revision_history_item
    assert_equal 'SHOGOUKI::NERV::1.1.1', @revision_history_item.version_id.value
    assert_equal 'MAGI', @revision_history_item.audits[0].system_id
  end

  def test_revision_history
    assert_equal 'NIGOUKI::NERV::2.2.2', @revision_history.most_recent_version
    assert_equal '2009-07-14T12:00:00', @revision_history.most_recent_version_time_committed
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
    object_version_id1 = Object_Version_ID.new('ABC::DEF::2.2.3')
    object_version_id2 = Object_Version_ID.new('GHI::JKL::4.5.6')
    object_id = Object_ID.new('ehr://uniqueid1020')
    dv_date_time = DV_Date_Time.new('2009-07-06T21:10:12')
    party_ref = Party_Ref.new('unknown', 'ORGANISATION', object_id)
    party_proxy = Party_Proxy.new(:external_ref => party_ref)
    terminology_id = Terminology_ID.new('openehr(1.0.2)')
    code_phrase = Code_Phrase.new('249', terminology_id)
    dv_coded_text = DV_Coded_Text.new('creation', code_phrase)
    audit_details = Audit_Details.new(:system_id => 'MAGI',
                                      :committer => party_proxy,
                                      :time_committed => dv_date_time,
                                      :change_type => dv_coded_text)
    code_phrase = Code_Phrase.new('532', terminology_id)
    dv_coded_text = DV_Coded_Text.new('complete', code_phrase)
    object_id = Object_ID.new('ehr://test_location')
    object_ref = Object_Ref.new('local', 'PARTY', object_id)
    hier_object_id = Hier_Object_ID.new('ABC')
    assert_nothing_raised(Exception){
      @version = Version.new(:uid => object_version_id1,
                             :preceding_version_uid => object_version_id2,
                             :lifecycle_state => dv_coded_text,
                             :commit_audit => audit_details,
                             :contribution => object_ref,
                             :signature => 'test_version',
                             :data => 'data')}
    object_version_id3 = Object_Version_ID.new('MNO::PQR::7.8.9')
    object_version_id4 = Object_Version_ID.new('STU::VWX::1.2.3')
    code_phrase = Code_Phrase.new('240', terminology_id)
    dv_coded_text2 = DV_Coded_Text.new('signed', code_phrase)
    attestation = Attestation.new(:system_id => 'NERV',
                                  :committer => party_proxy,
                                  :time_committed => dv_date_time,
                                  :change_type => dv_coded_text,
                                  :reason => DV_Text.new('signed'))
    assert_nothing_raised(Exception){
      @original_version = Original_Version.new(:uid => object_version_id3,
                                               :preceding_version_uid => object_version_id4,
                                               :other_input_version_uids => Set[object_version_id1, object_version_id2],
                                               :commit_audit => audit_details,
                                               :contribution => object_ref,
                                               :attestations => [attestation],
                                               :data => 'data',
                                               :lifecycle_state => dv_coded_text)}
  end

  def test_init
    assert_instance_of OpenEHR::RM::Common::Change_Control::Version, @version
    assert_instance_of Original_Version, @original_version
#    assert_instance_of OpenEHR::RM::Common::Change_Control::Contribution @contribution
  end

  def test_version
    assert_equal 'ABC::DEF::2.2.3', @version.uid.value
    assert !@version.uid.version_tree_id.is_first?
    assert_equal 'GHI::JKL::4.5.6', @version.preceding_version_uid.value
    assert_equal '532', @version.lifecycle_state.defining_code.code_string
    assert_equal 'MAGI', @version.commit_audit.system_id
    assert_equal 'local', @version.contribution.namespace
    assert_equal 'test_version', @version.signature
    assert_equal 'ABC', @version.owner_id.value
    assert_equal 'data', @version.data
    assert @version.is_branch?
  end

  def test_original_version
    assert_equal 'MNO::PQR::7.8.9', @original_version.uid.value
    assert_equal 'NERV', @original_version.attestations[0].system_id
  end

  def test_contribution
#    assert_equal @contribution.uid
  end
end
