require 'test/unit'
require 'set'
require 'rm'

include OpenEhr::RM::DataTypes::Text
include OpenEhr::RM::Common::Resource
include OpenEhr::RM::Common::Archetyped
include OpenEhr::RM::Common::Generic
include OpenEhr::RM::Common::ChangeControl
include OpenEhr::RM::Common::Directory
include OpenEhr::RM::Support::Identification
include OpenEhr::RM::DataTypes::Basic
include OpenEhr::RM::DataTypes::Quantity
include OpenEhr::RM::DataTypes::Uri

class RM_Common_Resource_Test < Test::Unit::TestCase
  def setup
    terminology_id = TerminologyId.new('openehr')
    code_phrase = CodePhrase.new('ja', terminology_id)
    @translation_details = OpenEhr::RM::Common::Resource::TranslationDetails.new(:language => code_phrase, :author => {'KOBAYASHI, Shinji', 'Ehime Univ'},
  :accreditation => 'jp', :other_details => {'ruby', 'test'})
    @authored_resource = OpenEhr::RM::Common::Resource::AuthoredResource.new(:original_language => code_phrase, :translations => {'ja', @translation_details}, :description => "test")
    @resource_description_item = OpenEhr::RM::Common::Resource::ResourceDescriptionItem.new(:language => code_phrase,
              :purpose => 'test',
              :keywords => %w[test ruby],
              :use => 'unit test',
              :misuse => 'real use',
              :copyright => 'openEHR.jp',
              :original_resource_uri => {'issuer', 'http://openehr.jp/'},
              :other_details => {'samos', 'icicth7'})
    @resource_description = OpenEhr::RM::Common::Resource::ResourceDescription.new(:original_author => {'KOBAYASHI, Shinji' => 'Ehime University'},
    :lifecycle_state => 'experimental',
    :details => {'ja', @resource_description_item},
    :other_contributors => %w[aki tim hugh],
    :resource_package_uri => 'http://openehr.jp/svn/ruby',
    :other_details => {'ja', 'shikoku'},
    :parent_resource => @authored_resource)
    @authored_resource = OpenEhr::RM::Common::Resource::AuthoredResource.new(:original_language => code_phrase, :translations => {'ja', @translation_details}, :description => @resource_description)
  end

  def test_init
    assert_instance_of OpenEhr::RM::Common::Resource::AuthoredResource, @authored_resource
    assert_instance_of OpenEhr::RM::Common::Resource::TranslationDetails, @translation_details
    assert_instance_of OpenEhr::RM::Common::Resource::ResourceDescriptionItem, @resource_description_item
    assert_instance_of OpenEhr::RM::Common::Resource::ResourceDescription, @resource_description
  end

  def test_translation_details
    assert_equal 'ja', @translation_details.language.code_string
    assert_equal 'Ehime Univ', @translation_details.author['KOBAYASHI, Shinji']
    assert_equal 'jp', @translation_details.accreditation
    assert_equal 'test', @translation_details.other_details['ruby']
  end

  def test_authoured_resource
    assert_equal 'ja', @authored_resource.original_language.code_string
    assert_equal @translation_details, @authored_resource.translations['ja']
    assert_equal 'experimental', @authored_resource.description.lifecycle_state
    assert !@authored_resource.is_controlled?
    assert_equal(Set['ja'], @authored_resource.languages_available)
  end

  def test_resource_description_item
    assert_equal 'ja', @resource_description_item.language.code_string
    assert_equal 'test', @resource_description_item.purpose
    assert_equal %w[test ruby], @resource_description_item.keywords
    assert_equal 'unit test', @resource_description_item.use
    assert_equal 'real use', @resource_description_item.misuse
    assert_equal 'openEHR.jp', @resource_description_item.copyright
    assert_equal 'http://openehr.jp/', @resource_description_item.original_resource_uri['issuer']
    assert_equal 'icicth7', @resource_description_item.other_details['samos']
  end

  def test_resource_description
    assert_equal 'Ehime University', @resource_description.original_author['KOBAYASHI, Shinji']
    assert_equal 'experimental', @resource_description.lifecycle_state
    assert_equal 'test', @resource_description.details['ja'].purpose
    assert_equal %w[aki tim hugh], @resource_description.other_contributors
    assert_equal 'http://openehr.jp/svn/ruby', @resource_description.resource_package_uri
    assert_equal 'shikoku', @resource_description.other_details['ja']
    assert_equal 'ja', @resource_description.parent_resource.original_language.code_string
  end
end


class RM_Common_Archetyped_Test < Test::Unit::TestCase
  def setup
    @dv_text = OpenEhr::RM::DataTypes::Text::DvText.new('Test')
    @uid_based_id = OpenEhr::RM::Support::Identification::UidBasedId.new('rrip::0.0.5')
    @archetype_id = OpenEhr::RM::Support::Identification::ArchetypeId.new("0.0.5", "biochemistry result_cholesterol", "entry", "ehr_rm", "openehr","cholesterol","0.0.3")
    @template_id = OpenEhr::RM::Support::Identification::TemplateId.new('1.0.1')
    assert_nothing_raised(Exception){@archetyped = OpenEhr::RM::Common::Archetyped::Archetyped.new(@archetype_id, '1.0.1')}
    assert_nothing_raised(Exception){@link = OpenEhr::RM::Common::Archetyped::Link.new(OpenEhr::RM::DataTypes::Text::DvText.new("generic"), OpenEhr::RM::DataTypes::Uri::DvEhrUri.new("ehr://test/"),OpenEhr::RM::DataTypes::Text::DvText.new("problem"))}
    assert_nothing_raised(Exception){
      @pathable = OpenEhr::RM::Common::Archetyped::Pathable.new }
    name = OpenEhr::RM::DataTypes::Text::DvText.new('blood')
    links = Set.new([@uid_based_id])
    assert_nothing_raised(Exception){
      @locatable = Locatable.new(:archetype_node_id => 'at0001',
                                 :name => name,
                                 :links => links)}
    provider = PartyIdentified.new(:name => 'NERV')
    location = PartyIdentified.new(:name => 'GEOFRONT')
    object_version_id = ObjectVersionId.new('ABC::DEF::1.3.4')
    party_ref = PartyRef.new('local', 'ORGANISATION', object_id)
    assert_nothing_raised(Exception){
      @feeder_audit_details = FeederAuditDetails.new(:system_id => 'MAGI',
                                                       :provider => provider,
                                                       :location => location,
                                                       :time => DvDateTime.new('2009-07-03T12:16:31'),
                                                       :subject => PartyProxy.new(:external_ref => party_ref),
                                                       :version_id => '0.0.4')}
    feeder_audit_details = FeederAuditDetails.new(:system_id => 'AKAGI')
    dv_identifier = DvIdentifier.new('NERV', 'MELCHIOR', 'RITSUKO', 'COMPUTER')
    feeder_audit_details2 = FeederAuditDetails.new(:system_id => 'KATSURAGI')
    dv_identifier2 = DvIdentifier.new('NERV', 'SHOGOUKI', 'MISATO', 'EVANGELION')
    charset = OpenEhr::RM::DataTypes::Text::CodePhrase.new('UTF-8','character-sets')
    language = OpenEhr::RM::DataTypes::Text::CodePhrase.new('ja', 'languages')

    dv_encapsulated = OpenEhr::RM::DataTypes::Encapsulated::DvEncapsulated.new(charset, language, 10)
    assert_nothing_raised(Exception){
      @feeder_audit = FeederAudit.new(:originating_system_audit => feeder_audit_details,
                                       :originating_system_item_ids => [dv_identifier],
                                       :feeder_system_audit => feeder_audit_details2,
                                       :feeder_system_item_ids => [dv_identifier2],
                                       :original_content => dv_encapsulated)}
  end

  def test_init
    assert_instance_of OpenEhr::RM::Common::Archetyped::Archetyped, @archetyped
    assert_instance_of OpenEhr::RM::Common::Archetyped::Link, @link
    assert_instance_of OpenEhr::RM::Common::Archetyped::Pathable, @pathable
    assert_instance_of OpenEhr::RM::Common::Archetyped::Locatable, @locatable
    assert_instance_of FeederAuditDetails, @feeder_audit_details
    assert_instance_of FeederAudit, @feeder_audit
  end

  def test_archetyped
    assert_equal @archetype_id, @archetyped.archetype_id
    assert_equal '1.0.1', @archetyped.rm_version
    assert_raise(ArgumentError){@archetyped.archetype_id = nil}
    assert_raise(ArgumentError){@archetyped.rm_version = nil}
    assert_raise(ArgumentError){@archetyped.rm_version = ''}
    assert_nothing_raised(Exception){@archetyped.template_id = @template_id}
    assert_equal @template_id, @archetyped.template_id
    archetype_id2 = OpenEhr::RM::Support::Identification::ArchetypeId.new("1.0.2", "biochemistry result_cholesterol", "entry", "ehr_rm", "openehr","cholesterol","0.0.3")
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
    assert_nothing_raised(Exception){@link.meaning = OpenEhr::RM::DataTypes::Text::DvText.new('clinical')}
    assert_equal 'clinical', @link.meaning.value
    assert_raise(ArgumentError){@link.meaning = nil}
    # test target
    assert_nothing_raised(Exception){@link.target = OpenEhr::RM::DataTypes::Uri::DvEhrUri.new("ehr://try/")}
    assert_equal 'ehr://try/', @link.target.value
    assert_raise(ArgumentError){@link.target = nil}
    # test type
    assert_nothing_raised(Exception){@link.type = OpenEhr::RM::DataTypes::Text::DvText.new("issue")}
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
    assert_nothing_raised(Exception){party_proxy = PartyProxy.new}
    object_id = ObjectId.new('0.0.4')
    party_ref = PartyRef.new('unknown', 'ORGANISATION', object_id)
    assert_nothing_raised(Exception){
      @party_proxy = PartyProxy.new(:external_ref => party_ref)}
    assert_nothing_raised(Exception){party_self = PartySelf.new}
    assert_nothing_raised(Exception){
      @party_self = PartySelf.new(:external_ref => party_ref)}
    assert_raise(ArgumentError){
      party_identified = PartyIdentified.new}

    identifiers = []
    identifiers << DvIdentifier.new('NERV', 'MELCHIOR', 'GENDO', 'COMPUTER')
    identifiers << DvIdentifier.new('NERV', 'CASPER', 'GENDO', 'COMPUTER')
    identifiers << DvIdentifier.new('NERV', 'BALTHAZAR', 'GENDO', 'COMPUTER')
    assert_nothing_raised(Exception){
      @party_identified = PartyIdentified.new(:name => 'NERV',
                                               :external_ref => party_ref,
                                               :identifier => identifiers)}

    terminology_id = TerminologyId.new('test(0.04)')
    code_phrase = CodePhrase.new('self', terminology_id)
    dv_coded_text = DvCodedText.new('Seele',code_phrase)
    assert_nothing_raised(Exception){
      @party_related = PartyRelated.new(:name => 'GEHIRN',
                                         :relationship => dv_coded_text)}
    dv_text = DvText.new('commiter')
    dv_coded_text = DvCodedText.new('present',terminology_id)
    dv_date_time1 = DvDateTime.new('2009-07-04T16:30:00')
    dv_date_time2 = DvDateTime.new('2009-07-14T00:00:00')
    dv_interval = DvInterval.new(dv_date_time1, dv_date_time2)
    assert_nothing_raised(Exception){
      @participation = Participation.new(:performer => @party_proxy,
                                         :function => dv_text,
                                         :mode => dv_coded_text,
                                         :time => dv_interval)}
    dv_date_time = DvDateTime.new('2009-07-04T18:56:00')
    terminology_id = TerminologyId.new('openehr(1.0.2)')
    code_phrase = CodePhrase.new('249', terminology_id)
    dv_coded_text = DvCodedText.new('creation', code_phrase)
    dv_text = DvText.new('test environment')
    assert_nothing_raised(Exception){
      @audit_details = AuditDetails.new(:system_id => 'MAGI',
                                         :committer => @party_proxy,
                                         :time_committed => dv_date_time,
                                         :change_type => dv_coded_text,
                                         :description => dv_text)}
    dv_text = DvText.new('authorisation')
    dv_ehr_uri = DvEhrUri.new('ehr://test/')
    assert_nothing_raised(Exception){
      @attestation = Attestation.new(:system_id => 'NERV',
                                     :committer => @party_proxy,
                                     :time_committed => dv_date_time,
                                     :change_type => dv_coded_text,
                                     :reason => dv_text,
                                     :description => dv_text,
                                     :proof => 'hashedstring',
                                     :items => Set[dv_ehr_uri])}
    object_version_id = ObjectVersionId.new('SHOGOUKI::NERV::1.1.1')
    audit_details2 = AuditDetails.new(:system_id => 'MAGI',
                                       :committer => @party_proxy,
                                       :time_committed => dv_date_time2,
                                       :change_type => dv_coded_text)
    assert_nothing_raised(Exception){
      @revision_history_item = RevisionHistoryItem.new(:audits => [@audit_details, audit_details2],
                                                         :version_id => object_version_id)}
    dv_date_time3 = DvDateTime.new('2009-07-14T12:00:00')
    dv_date_time4 = DvDateTime.new('2009-07-15T00:00:00')
    audit_details3 = AuditDetails.new(:system_id => 'MAGI',
                                     :committer => @party_proxy,
                                     :time_committed => dv_date_time3,
                                     :change_type => dv_coded_text)
    audit_details4 = AuditDetails.new(:system_id => 'MAGI',
                                     :committer => @party_proxy,
                                     :time_committed => dv_date_time4,
                                     :change_type => dv_coded_text)
    object_version_id = ObjectVersionId.new('NIGOUKI::NERV::2.2.2')
    revision_history_item2 = RevisionHistoryItem.new(:audits => [audit_details3, audit_details4],
                                                      :version_id => object_version_id)
    assert_nothing_raised(Exception){
      @revision_history = RevisionHistory.new([@revision_history_item, revision_history_item2])}
  end

  def test_init
    assert_instance_of PartyProxy, @party_proxy
    assert_instance_of PartySelf, @party_self
    assert_instance_of PartyIdentified, @party_identified
    assert_instance_of Participation, @participation
    assert_instance_of AuditDetails, @audit_details
    assert_instance_of Attestation, @attestation
    assert_instance_of RevisionHistoryItem, @revision_history_item
    assert_instance_of RevisionHistory, @revision_history
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
    archetype_node_id = 'at0001'
    name = DvText.new('folder_test')
    object_id = ObjectId.new('1.1.1')
    object_ref = ObjectRef.new('local', 'PARTY', object_id)
    assert_nothing_raised(Exception){
      @folder = Folder.new(:archetype_node_id => archetype_node_id,
                           :name => name,
                           :items => [object_ref])}
    

  end
  
  def test_init
    assert_instance_of OpenEhr::RM::Common::Directory::Folder, @folder
  end

  def test_folder
    assert_equal 'at0001', @folder.archetype_node_id
    assert_equal 'local', @folder.items[0].namespace
  end
end

class RM_Common_Change_Control_Test < Test::Unit::TestCase
  def setup
    object_version_id1 = ObjectVersionId.new('ABC::DEF::2.2.3')
    object_version_id2 = ObjectVersionId.new('GHI::JKL::4.5.6')
    object_id = ObjectId.new('ehr://uniqueid1020')
    dv_date_time = DvDateTime.new('2009-07-06T21:10:12')
    party_ref = PartyRef.new('unknown', 'ORGANISATION', object_id)
    party_proxy = PartyProxy.new(:external_ref => party_ref)
    terminology_id = TerminologyId.new('openehr(1.0.2)')
    code_phrase = CodePhrase.new('249', terminology_id)
    dv_coded_text = DvCodedText.new('creation', code_phrase)
    audit_details = AuditDetails.new(:system_id => 'MAGI',
                                      :committer => party_proxy,
                                      :time_committed => dv_date_time,
                                      :change_type => dv_coded_text)
    code_phrase = CodePhrase.new('532', terminology_id)
    dv_coded_text = DvCodedText.new('complete', code_phrase)
    object_id = ObjectId.new('ehr://test_location')
    object_ref = ObjectRef.new('local', 'PARTY', object_id)
    hier_object_id = HierObjectId.new('ABC')
    assert_nothing_raised(Exception){
      @version = Version.new(:uid => object_version_id1,
                             :preceding_version_uid => object_version_id2,
                             :lifecycle_state => dv_coded_text,
                             :commit_audit => audit_details,
                             :contribution => object_ref,
                             :signature => 'test_version',
                             :data => 'data')}
    object_version_id3 = ObjectVersionId.new('MNO::PQR::7.8.9')
    object_version_id4 = ObjectVersionId.new('STU::VWX::1.2.3')
    code_phrase = CodePhrase.new('240', terminology_id)
    dv_coded_text2 = DvCodedText.new('signed', code_phrase)
    attestation = Attestation.new(:system_id => 'NERV',
                                  :committer => party_proxy,
                                  :time_committed => dv_date_time,
                                  :change_type => dv_coded_text,
                                  :reason => DvText.new('signed'))
    dv_date_time = DvDateTime.new('2009-07-07T21:10:12')
    audit_details = AuditDetails.new(:system_id => 'MAGI',
                                      :committer => party_proxy,
                                      :time_committed => dv_date_time,
                                      :change_type => dv_coded_text)
    assert_nothing_raised(Exception){
      @original_version = OriginalVersion.new(:uid => object_version_id3,
                                               :preceding_version_uid => object_version_id4,
                                               :other_input_version_uids => Set[object_version_id1, object_version_id2],
                                               :commit_audit => audit_details,
                                               :contribution => object_ref,
                                               :attestations => [attestation],
                                               :data => 'data',
                                               :lifecycle_state => dv_coded_text)}
    dv_date_time = DvDateTime.new('2009-07-08T21:10:12')
    audit_details = AuditDetails.new(:system_id => 'CASPER',
                                      :committer => party_proxy,
                                      :time_committed => dv_date_time,
                                      :change_type => dv_coded_text,
                                      :description => 'for contribution')
    object_ref = ObjectRef.new('unknown', 'PARTY', object_id)
    assert_nothing_raised(Exception){
      @imported_version = ImportedVersion.new(:item => @original_version,
                                               :commit_audit => audit_details,
                                               :contribution => object_ref,
                                               :signature => 'import test')}
    assert_nothing_raised(Exception){
      @contribution = Contribution.new(:uid => hier_object_id,
                                       :versions => Set[object_ref],
                                       :audit => audit_details)}
    dv_date_time = DvDateTime.new('2009-07-08T18:10:12')
    audit_details = AuditDetails.new(:system_id => 'MAGI',
                                      :committer => party_proxy,
                                      :time_committed => dv_date_time,
                                      :change_type => dv_coded_text)
    @trunk_version = Version.new(:uid => object_version_id4,
                                :lifecycle_state => dv_coded_text,
                                :commit_audit => audit_details,
                                :contribution => object_ref,
                                :change_type => dv_coded_text)
    assert_nothing_raised(Exception){
      @versioned_object = VersionedObject.new(:uid => hier_object_id,
                                               :owner_id => object_ref,
                                               :time_created => dv_date_time,
                                               :all_versions => [@version,@original_version,@imported_version,@trunk_version])}
  end

  def test_init
    assert_instance_of OpenEhr::RM::Common::ChangeControl::Version, @version
    assert_instance_of OriginalVersion, @original_version
    assert_instance_of ImportedVersion, @imported_version
    assert_instance_of OpenEhr::RM::Common::ChangeControl::Contribution, @contribution
    assert_instance_of VersionedObject, @versioned_object
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

  def test_imported_version
    assert_equal 'import test', @imported_version.signature
    assert_equal 'MNO::PQR::7.8.9', @imported_version.item.uid.value
    assert_equal 'CASPER', @imported_version.commit_audit.system_id
    assert_equal 'unknown', @imported_version.contribution.namespace
    assert_equal 'STU::VWX::1.2.3', @imported_version.preceding_version_uid.value
    assert_equal '532', @imported_version.lifecycle_state.defining_code.code_string
  end

  def test_contribution
    assert_equal 'ABC', @contribution.uid.value
    assert_equal 'PARTY', @contribution.versions.to_a[0].type
    assert_equal 'for contribution', @contribution.audit.description
  end

  def test_versioned_object
    assert_equal 'ABC', @versioned_object.uid.value
    assert_equal 'unknown', @versioned_object.owner_id.namespace
    assert_equal 18, @versioned_object.time_created.hour
    assert_equal [@version, @original_version, @imported_version, @trunk_version],
                    @versioned_object.all_versions
    assert_equal 4, @versioned_object.version_count
    assert_equal [@version.uid, @original_version.uid, @imported_version.uid, @trunk_version.uid],
                   @versioned_object.all_version_ids
    assert @versioned_object.has_version_id?(@version.uid)
    assert !@versioned_object.is_original_version?(@version.uid)
    assert @versioned_object.is_original_version?(@original_version.uid)
    assert @versioned_object.has_version_at_time?(DvDateTime.new('2009-07-06T21:10:12'))
    assert_equal @version, @versioned_object.version_with_id(@version.uid)
    assert_equal @version, @versioned_object.version_at_time(@version.commit_audit.time_committed)
    assert_equal @imported_version, @versioned_object.latest_version
    assert_equal @trunk_version, @versioned_object.latest_trunk_version
    assert_equal 'complete', @versioned_object.trunk_lifecycle_state.value
    assert_equal '2009-07-08T18:10:12', @versioned_object.revision_history.most_recent_version_time_committed
    assert_nothing_raised(Exception){
      @versioned_object.commit_original_version(:contribution => @original_version.contribution,
                                                :uid => @original_version.uid,
                                                :preceding_version_uid => @original_version.preceding_version_uid,
                                                :commit_audit => @original_version.commit_audit,
                                                :attestations => @original_version.attestations,
                                                :lifecycle_state => @original_version.lifecycle_state,
                                                :data => 'commit original',
                                                :signature => 'testtett')}
    assert_equal 5, @versioned_object.version_count
    assert_nothing_raised(Exception){
      @versioned_object.commit_original_merged_version(:contribution => @original_version.contribution,
                                                       :uid => @original_version.uid,
                                                       :preceding_version_uid => @original_version.preceding_version_uid,
                                                       :commit_audit => @original_version.commit_audit,
                                                       :lifecycle_state => @original_version.lifecycle_state,
                                                       :attestations => @original_version.attestations,
                                                       :data => @original_version.data,
                                                       :other_input_version_uids => @original_version.other_input_version_uids,
                                                       :signature => @original_version.signature)}
    assert_equal 6, @versioned_object.version_count
    assert_nothing_raised(Exception){
      @versioned_object.commit_imported_version(:contribution => @imported_version.contribution,
                                                :commit_audit => @imported_version.commit_audit,
                                                :item => @imported_version.item)}
    assert_equal 7, @versioned_object.version_count
    dv_date_time = DvDateTime.new('2009-07-07T22:11:31')
    attestation = Attestation.new(:system_id => 'NERV2',
                                  :committer => @version.contribution,
                                  :time_committed => dv_date_time,
                                  :change_type => @original_version.commit_audit.change_type,
                                  :reason => DvText.new('signed'))
    assert_nothing_raised(Exception){
      @versioned_object.commit_attestation(:attestation => attestation,
                                           :uid => @original_version.uid,
                                           :signature => 'new signature')}
  end
end
