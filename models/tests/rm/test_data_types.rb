require 'test/unit'
require 'set'
require 'rm'

class RM_Data_Types_Basic_Test < Test::Unit::TestCase
  def setup
    assert_nothing_raised(Exception){@dv_boolean = OpenEHR::RM::Data_Types::Basic::DV_Boolean.new("TRUE")}
    @terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new('openEHR','1.0.2')
    @code_phrase = OpenEHR::RM::Data_Types::Text::Code_Phrase.new('PROPOSED', @terminology_id)
    @dv_coded_text = OpenEHR::RM::Data_Types::Text::DV_Coded_Text.new("Blood examination", @code_phrase)
    assert_nothing_raised(Exception){@dv_state = OpenEHR::RM::Data_Types::Basic::DV_State.new(@dv_coded_text, false)}
    assert_nothing_raised(Exception){@dv_identifier = OpenEHR::RM::Data_Types::Basic::DV_Identifier.new("Ruby Hospital","0123456-0", "Information office", "personal id")}
  end

  def test_init
    assert_instance_of OpenEHR::RM::Data_Types::Basic::DV_Boolean, @dv_boolean
    assert_instance_of OpenEHR::RM::Data_Types::Basic::DV_State, @dv_state
    assert_instance_of OpenEHR::RM::Data_Types::Basic::DV_Identifier, @dv_identifier
  end

  def test_constant
    assert_equal("\r", OpenEHR::RM::Data_Types::Basic::Data_Value::CR)
    assert_equal("\n", OpenEHR::RM::Data_Types::Basic::Data_Value::LF)
  end

  def test_dv_boolean
    assert @dv_boolean.value?
    @dv_boolean.value = false
    assert !@dv_boolean.value?
    # inv: Value_exists
    assert_raise(ArgumentError){@dv_boolean.value=nil}
    assert_raise(ArgumentError){OpenEHR::RM::Data_Types::Basic::DV_Boolean.new(nil)}
  end

  def test_dv_state
    assert_equal 'Blood examination', @dv_state.value.value
    assert_equal 'PROPOSED', @dv_state.value.defining_code.code_string
    assert_equal 'openEHR', @dv_state.value.defining_code.terminology_id.name
    assert_equal '1.0.2', @dv_state.value.defining_code.terminology_id.version_id
    assert !@dv_state.is_terminal?
    assert_nothing_raised(Exception){@dv_state.value.defining_code.code_string = "COMPLETED"}
    assert_nothing_raised(Exception){@dv_state.is_terminal = true}
    assert_equal 'COMPLETED', @dv_state.value.defining_code.code_string
    assert @dv_state.is_terminal?
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
end

# fixed
class RM_Data_Types_URI_Test < Test::Unit::TestCase
  def setup
    @dv_uri = OpenEHR::RM::Data_Types::URI::DV_URI.new("http://www.openehr.jp/changeset/test?cmd=93#file0")
    @dv_ehr_uri = OpenEHR::RM::Data_Types::URI::DV_EHR_URI.new("ehr://1234567/87284370-2D4B-4e3d-A3F3-F303D2F4F34B@2005-08-02T04:30:00")
  end

  def test_init
    assert_instance_of OpenEHR::RM::Data_Types::URI::DV_URI, @dv_uri
    assert_instance_of OpenEHR::RM::Data_Types::URI::DV_EHR_URI, @dv_ehr_uri    
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
end

class RM_Data_Types_Text_Test < Test::Unit::TestCase
  def setup
    assert_nothing_raised(Exception){@dv_text = OpenEHR::RM::Data_Types::Text::DV_Text.new("valid value")}
    @terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new('ICD10', '')
    
    assert_nothing_raised(Exception){@code_phrase = OpenEHR::RM::Data_Types::Text::Code_Phrase.new('C92.0', @terminology_id)}
    assert_nothing_raised(Exception){@dv_coded_text = OpenEHR::RM::Data_Types::Text::DV_Coded_Text.new("Acute Myeloid Leukemia", @code_phrase)}
    @dv_paragraph = OpenEHR::RM::Data_Types::Text::DV_Paragraph.new(Set.new(["test1", "test2"]))
    @term_mapping = OpenEHR::RM::Data_Types::Text::Term_Mapping.new('=',@dv_coded_text,"TEST")
  end

  def test_init
    assert_instance_of OpenEHR::RM::Data_Types::Text::DV_Text, @dv_text
    assert_instance_of OpenEHR::RM::Data_Types::Text::Code_Phrase, @code_phrase
    assert_instance_of OpenEHR::RM::Data_Types::Text::DV_Coded_Text, @dv_coded_text
    assert_instance_of OpenEHR::RM::Data_Types::Text::Term_Mapping, @term_mapping
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

  def test_code_phrase
    assert_equal 'C92.0', @code_phrase.code_string
    assert_equal 'ICD10', @code_phrase.terminology_id.value
    assert_nothing_raised(Exception){@code_phrase.code_string = 'C93.0'}
    assert_equal 'C93.0', @code_phrase.code_string
  end

  def test_dv_coded_text
    assert_equal("Acute Myeloid Leukemia", @dv_coded_text.value)
    assert_equal("ICD10", @dv_coded_text.defining_code.terminology_id.name)
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

class QuantityTest < Test::Unit::TestCase
  def setup
    assert_nothing_raised(Exception){
      @dv_ordered = OpenEHR::RM::Data_Types::Quantity::DV_Ordered.new }
    assert_nothing_raised(Exception){
      @dv_interval = OpenEHR::RM::Data_Types::Quantity::Date_Time::DV_Interval.new}
    meaning = OpenEHR::RM::Data_Types::Text::DV_Text.new('normal')
    assert_nothing_raised(Exception){
      @reference_range = OpenEHR::RM::Data_Types::Quantity::Reference_Range.new(meaning)}
    assert_nothing_raised(Exception){
      @dv_ordinal = OpenEHR::RM::Data_Types::Quantity::DV_Ordinal.new(1,'+')}
    assert_nothing_raised(Exception){
      @dv_quantified = OpenEHR::RM::Data_Types::Quantity::DV_Quantified.new }
    assert_nothing_raised(Exception){
      @dv_amount = OpenEHR::RM::Data_Types::Quantity::DV_Amount.new}
    assert_nothing_raised(Exception){
      @dv_quantity = OpenEHR::RM::Data_Types::Quantity::DV_Quantity.new}
   end

   def test_init
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Ordered, @dv_ordered
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Quantified, @dv_quantified
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::Date_Time::DV_Interval, @dv_interval
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::Reference_Range, @reference_range
     
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Ordinal, @dv_ordinal
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Quantified, @dv_quantified
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Amount, @dv_amount
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Quantity, @dv_quantity
  end

  def test_dv_ordered
    assert !@dv_ordered.is_normal?
    assert_nil @dv_ordered.normal_status
    assert_nil @dv_ordered.normal_range
    assert_nil @dv_ordered.other_refference_ranges
    assert @dv_ordered.is_simple?
    assert_raise(NotImplementedError){@dv_ordered<=>1}
    openehr_terminology_id = OpenEHR::RM::Support::Identification::Terminology_ID.new('openEHR','')
    normal_code = OpenEHR::RM::Data_Types::Text::Code_Phrase.new('N', openehr_terminology_id)
    assert_equal 'N', normal_code.code_string
    assert_nothing_raised(Exception){
      @dv_ordered.normal_status = normal_code }
    assert @dv_ordered.is_normal?
    other = OpenEHR::RM::Data_Types::Quantity::DV_Ordered.new
    assert_raise(NotImplementedError){
      @dv_ordered.is_strictry_comparable_to?(other)}
  end

  def test_reference_range
    assert_equal 'normal', @reference_range.meaning.value
  end

  def test_dv_quantified
    
  end

  def test_dv_amount

  end

  def test_dv_interval
    
  end

  def test_dv_ordinal
    
  end

  def test_proportion_kind
    assert_equal 0, OpenEHR::RM::Data_Types::Quantity::Proportion_Kind::PK_RATIO
    assert_equal 1, OpenEHR::RM::Data_Types::Quantity::Proportion_Kind::PK_UNITARY
    assert_equal 2, OpenEHR::RM::Data_Types::Quantity::Proportion_Kind::PK_PERCENT
    assert_equal 3, OpenEHR::RM::Data_Types::Quantity::Proportion_Kind::PK_FRACTION
    assert_equal 4, OpenEHR::RM::Data_Types::Quantity::Proportion_Kind::PK_INTEGER_FRACTION
    assert OpenEHR::RM::Data_Types::Quantity::Proportion_Kind.valid_proportion_kind?(0)
    assert OpenEHR::RM::Data_Types::Quantity::Proportion_Kind.valid_proportion_kind?(4)
    assert !OpenEHR::RM::Data_Types::Quantity::Proportion_Kind.valid_proportion_kind?(-1)
    assert !OpenEHR::RM::Data_Types::Quantity::Proportion_Kind.valid_proportion_kind?(5)
  end
end

class QuantityDateTimeTest < Test::Unit::TestCase
  def setup
    assert_nothing_raised(Exception){
      @dv_temporal = OpenEHR::RM::Data_Types::Quantity::Date_Time::DV_Temporal.new('2008')}
  end
  def test_init
    assert_instance_of OpenEHR::RM::Data_Types::Quantity::Date_Time::DV_Temporal, @dv_temporal
  end

  def test_dv_temporal
    assert_equal '2008', @dv_temporal.value
    assert_raise(NotImplementedError){@dv_temporal.diff('2009')}
  end
end

class EncapsulatedTest < Test::Unit::TestCase
  def setup
    charset = OpenEHR::RM::Data_Types::Text::Code_Phrase.new('UTF-8','character-sets')
    language = OpenEHR::RM::Data_Types::Text::Code_Phrase.new('ja', 'languages')
    assert_nothing_raised(Exception){
      @dv_encapsulated = OpenEHR::RM::Data_Types::Encapsulated::DV_Encapsulated.new(charset, language, 10)}
    assert_nothing_raised(Exception){
      @dv_parsable = OpenEHR::RM::Data_Types::Encapsulated::DV_Parsable.new(charset, language, 10, 'XML','<TEST>test</TEST>')}
    media_type = OpenEHR::RM::Data_Types::Text::Code_Phrase.new('text/html', 'media-types')
    uri = OpenEHR::RM::Data_Types::URI::DV_URI.new("http://www.openehr.jp/changeset/test?cmd=93#file0")
    assert_nothing_raised(Exception){
      @dv_multimedia = OpenEHR::RM::Data_Types::Encapsulated::DV_Multimedia.new(charset, language, 10, media_type, uri)}
  end

  def test_init
    assert_instance_of OpenEHR::RM::Data_Types::Encapsulated::DV_Encapsulated, @dv_encapsulated
    assert_instance_of OpenEHR::RM::Data_Types::Encapsulated::DV_Parsable, @dv_parsable
    assert_instance_of OpenEHR::RM::Data_Types::Encapsulated::DV_Multimedia, @dv_multimedia
  end

  def test_dv_encapsulated
    assert_equal 'UTF-8', @dv_encapsulated.charset.code_string
    assert_equal 'ja', @dv_encapsulated.language.code_string
    assert_equal 10, @dv_encapsulated.size
    wrong_charset = OpenEHR::RM::Data_Types::Text::Code_Phrase.new('USO8000', 'character-sets')
    assert_raise(ArgumentError){@dv_encapsulated.charset = wrong_charset}
    charset = OpenEHR::RM::Data_Types::Text::Code_Phrase.new('EUC-JP', 'character-sets')
    assert_nothing_raised(Exception){@dv_encapsulated.charset = charset}
    assert_equal 'EUC-JP', @dv_encapsulated.charset.code_string
    wrong_language = OpenEHR::RM::Data_Types::Text::Code_Phrase.new('jpg', 'language')
    assert_raise(ArgumentError){@dv_encapsulated.language = wrong_language}
    language = OpenEHR::RM::Data_Types::Text::Code_Phrase.new('eng', 'language')
    assert_nothing_raised(Exception){@dv_encapsulated.language = language}
    assert_equal 'eng', @dv_encapsulated.language.code_string
    assert_raise(ArgumentError){@dv_encapsulated.size = -1}
    assert_nothing_raised(Exception){@dv_encapsulated.size = 0}
    assert_equal 0, @dv_encapsulated.size
  end

  def test_dv_parsable
    assert_equal 'UTF-8', @dv_parsable.charset.code_string
    assert_equal 'ja', @dv_parsable.language.code_string
    assert_equal 10, @dv_parsable.size
    assert_equal 'XML', @dv_parsable.formalism
    assert_equal '<TEST>test</TEST>', @dv_parsable.value
    assert_raise(ArgumentError){
      @dv_parsable.formalism = nil }
    assert_nothing_raised(Exception){
      @dv_parsable.formalism = 'HTML' }
    assert_equal 'HTML', @dv_parsable.formalism
    assert_raise(ArgumentError){
      @dv_parsable.value = nil }
    assert_nothing_raised(Exception){
      @dv_parsable.value = '<H1>test</H1>' }
    assert_equal '<H1>test</H1>', @dv_parsable.value
  end

  def test_dv_multimedia
    assert_equal 'UTF-8', @dv_multimedia.charset.code_string
    assert_equal 'ja', @dv_multimedia.language.code_string
    assert_equal 10, @dv_multimedia.size
    assert_equal 'text/html', @dv_multimedia.media_type.code_string
    assert_equal 'http://www.openehr.jp/changeset/test?cmd=93#file0', @dv_multimedia.uri.value
  end
end
