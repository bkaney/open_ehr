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
      terminology = OpenEHR::RM::Support::Identification::Terminology_ID.new('urine', '')
      code_phrase = OpenEHR::RM::Data_Types::Text::Code_Phrase.new('protein',terminology)
      urinary_protein = OpenEHR::RM::Data_Types::Text::DV_Coded_Text.new('+', code_phrase)
      @dv_ordinal1 = OpenEHR::RM::Data_Types::Quantity::DV_Ordinal.new(1, urinary_protein)
      code_phrase = OpenEHR::RM::Data_Types::Text::Code_Phrase.new('protein',terminology)
      urinary_protein = OpenEHR::RM::Data_Types::Text::DV_Coded_Text.new('+++', code_phrase)
      @dv_ordinal2 = OpenEHR::RM::Data_Types::Quantity::DV_Ordinal.new(3, urinary_protein)}
    assert_nothing_raised(Exception){
      @dv_interval = OpenEHR::RM::Data_Types::Quantity::DV_Interval.new(@dv_ordinal1, @dv_ordinal2)}
    meaning = OpenEHR::RM::Data_Types::Text::DV_Text.new('normal')
    assert_nothing_raised(Exception){
      @reference_range = OpenEHR::RM::Data_Types::Quantity::Reference_Range.new(meaning, @dv_interval)}
    assert_nothing_raised(Exception){
      @dv_quantified = OpenEHR::RM::Data_Types::Quantity::DV_Quantified.new(1,'=')}
    assert_nothing_raised(Exception){
      @dv_amount = OpenEHR::RM::Data_Types::Quantity::DV_Amount.new(2,'<')}
    assert_nothing_raised(Exception){
      @dv_quantity = OpenEHR::RM::Data_Types::Quantity::DV_Quantity.new(3, 'mg', '~')}
    assert_nothing_raised(Exception){
      @dv_count = OpenEHR::RM::Data_Types::Quantity::DV_Count.new(1)}
    assert_nothing_raised(Exception){
      @dv_proportion = OpenEHR::RM::Data_Types::Quantity::DV_Proportion.new(2,3,0)}
   end

   def test_init
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Ordered, @dv_ordered
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Quantified, @dv_quantified
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Interval, @dv_interval
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::Reference_Range, @reference_range
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Ordinal, @dv_ordinal1
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Ordinal, @dv_ordinal2
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Quantified, @dv_quantified
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Amount, @dv_amount
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Quantity, @dv_quantity
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Count, @dv_count
     assert_instance_of OpenEHR::RM::Data_Types::Quantity::DV_Proportion, @dv_proportion
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
      @dv_ordered.is_strictly_comparable_to?(other)}
  end

  def test_dv_interval
    assert @dv_interval.lower < @dv_interval.upper
  end

  def test_reference_range
    assert_equal 'normal', @reference_range.meaning.value
    assert_equal 1, @reference_range.range.lower.value
    terminology = OpenEHR::RM::Support::Identification::Terminology_ID.new('urine', '')
    code_phrase = OpenEHR::RM::Data_Types::Text::Code_Phrase.new('protein',terminology)
    urinary_protein = OpenEHR::RM::Data_Types::Text::DV_Coded_Text.new('++', code_phrase)
    dv_ordinal = OpenEHR::RM::Data_Types::Quantity::DV_Ordinal.new(2, urinary_protein)
    assert @reference_range.is_in_range?(dv_ordinal)
    dv_ordinal.value = 6
    assert !@reference_range.is_in_range?(dv_ordinal)
  end

  def test_dv_quantified
    assert_equal 1, @dv_quantified.magnitude
    assert_equal '=', @dv_quantified.magnitude_status
    assert !OpenEHR::RM::Data_Types::Quantity::DV_Quantified.valid_magnitude_status?('*')
    assert OpenEHR::RM::Data_Types::Quantity::DV_Quantified.valid_magnitude_status?('>')
    assert OpenEHR::RM::Data_Types::Quantity::DV_Quantified.valid_magnitude_status?('<')
    assert OpenEHR::RM::Data_Types::Quantity::DV_Quantified.valid_magnitude_status?('>=')
    assert OpenEHR::RM::Data_Types::Quantity::DV_Quantified.valid_magnitude_status?('<=')
    assert OpenEHR::RM::Data_Types::Quantity::DV_Quantified.valid_magnitude_status?('~')
    assert_nothing_raised(Exception){@dv_quantified.magnitude = 0}
    assert_equal 0, @dv_quantified.magnitude
    assert_nothing_raised(Exception){@dv_quantified.magnitude_status = nil}
    assert_equal '=',  @dv_quantified.magnitude_status
  end

  def test_dv_amount
    assert_equal 2, @dv_amount.magnitude
    assert_equal '<', @dv_amount.magnitude_status
    assert @dv_amount.accuracy_unknown?
    assert_nothing_raised(Exception){@dv_amount.set_accuracy(50,true)}
    assert_equal 50, @dv_amount.accuracy
    assert @dv_amount.accuracy_is_percent?
    assert_nothing_raised(Exception){@dv_amount.set_accuracy(0.3, false)}
    assert_equal 0.3, @dv_amount.accuracy
    assert !@dv_amount.accuracy_is_percent?
    assert !@dv_amount.accuracy_unknown?
  end

  def test_dv_ordinal
    assert_equal 1, @dv_ordinal1.value
    assert_equal '+', @dv_ordinal1.symbol.value
    assert_raise(ArgumentError){@dv_ordinal1.symbol = nil}
    assert_raise(ArgumentError){@dv_ordinal1.value = nil}
    assert @dv_ordinal1.is_strictly_comparable_to?(@dv_ordinal2)
    assert @dv_ordinal1 < @dv_ordinal2
    assert @dv_ordinal2 > @dv_ordinal1
    @dv_ordinal1.value = 4
    assert 4, @dv_ordinal1.value
    assert @dv_ordinal1 > @dv_ordinal2
    assert_raise(ArgumentError){@dv_ordinal1.limits = @reference_range}
    meaning = OpenEHR::RM::Data_Types::Text::DV_Text.new('limits')
    limit_reference_range = OpenEHR::RM::Data_Types::Quantity::Reference_Range.new(meaning, @dv_interval)
    assert_nothing_raised(Exception){@dv_ordinal1.limits = limit_reference_range}
    assert_equal 'limits', @dv_ordinal1.limits.meaning.value
  end

  def test_dv_quantity
    assert_equal 3, @dv_quantity.magnitude
    assert_equal 'mg', @dv_quantity.units
    assert_equal '~', @dv_quantity.magnitude_status
    dv_quantity2 = OpenEHR::RM::Data_Types::Quantity::DV_Quantity.new(4, 'mg', '~')
    assert_equal 'mg', dv_quantity2.units
    assert @dv_quantity.is_strictly_comparable_to?(dv_quantity2)
    assert_nothing_raised(Exception){@dv_quantity.precision = -1}
    assert_equal(-1, @dv_quantity.precision)
    assert !@dv_quantity.is_integral?
    assert_raise(ArgumentError){@dv_quantity.precision = -1.1}
    @dv_quantity.precision = 0
    assert @dv_quantity.is_integral?
    dv_quantity3 = @dv_quantity + dv_quantity2
    assert_equal 7, dv_quantity3.magnitude
    assert_equal 'mg', dv_quantity3.units
    dv_quantity3 = @dv_quantity - dv_quantity2
    assert_equal(-1, dv_quantity3.magnitude)
    assert_equal 'mg', dv_quantity3.units
  end

  def test_dv_count
    assert_equal 1, @dv_count.magnitude
    dv_count2 = OpenEHR::RM::Data_Types::Quantity::DV_Count.new(2)
    dv_count3 = @dv_count + dv_count2
    assert 3, dv_count3.magnitude
    dv_count3 = dv_count2 - @dv_count
    assert 1, dv_count3.magnitude
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

  def test_dv_proportion
    assert_equal 2.0, @dv_proportion.numerator
    assert_equal 3.0, @dv_proportion.denominator
    assert_equal 0, @dv_proportion.type
    assert_equal 2.0/3.0, @dv_proportion.magnitude
    assert @dv_proportion.is_integral?
    dv_proportion2 = OpenEHR::RM::Data_Types::Quantity::DV_Proportion.new(1,3,0)
    assert @dv_proportion.is_strictly_comparable_to?(dv_proportion2)
    dv_proportion2 = OpenEHR::RM::Data_Types::Quantity::DV_Proportion.new(1,3,4)
    assert !@dv_proportion.is_strictly_comparable_to?(dv_proportion2)
    assert_raise(ArgumentError){
      dv_proportion2 = OpenEHR::RM::Data_Types::Quantity::DV_Proportion.new(1.5,2.3,3)}
    assert_raise(ArgumentError){
      dv_proportion2 = OpenEHR::RM::Data_Types::Quantity::DV_Proportion.new(10,10,1)}
    assert_nothing_raised(Exception){
      dv_proportion2 = OpenEHR::RM::Data_Types::Quantity::DV_Proportion.new(10,1,1)}
    assert_raise(ArgumentError){
      dv_proportion2 = OpenEHR::RM::Data_Types::Quantity::DV_Proportion.new(10,10,2)}
    assert_nothing_raised(Exception){
      dv_proportion2 = OpenEHR::RM::Data_Types::Quantity::DV_Proportion.new(10,100,2)}
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
