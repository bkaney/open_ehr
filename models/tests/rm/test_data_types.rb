require 'test/unit'
require 'set'
require 'rm'
require 'tests/rm/quantity/ts_date_time'

class RM_Data_Types_Basic_Test < Test::Unit::TestCase
  def setup
    assert_nothing_raised(Exception){@dv_boolean = OpenEhr::RM::DataTypes::Basic::DvBoolean.new("TRUE")}
    @terminology_id = OpenEhr::RM::Support::Identification::TerminologyId.new('openEHR(1.0.2)')
    @code_phrase = OpenEhr::RM::DataTypes::Text::CodePhrase.new('PROPOSED', @terminology_id)
    @dv_coded_text = OpenEhr::RM::DataTypes::Text::DvCodedText.new("Blood examination", @code_phrase)
    assert_nothing_raised(Exception){@dv_state = OpenEhr::RM::DataTypes::Basic::DvState.new(@dv_coded_text, false)}
    assert_nothing_raised(Exception){@dv_identifier = OpenEhr::RM::DataTypes::Basic::DvIdentifier.new("Ruby Hospital","0123456-0", "Information office", "personal id")}
  end

  def test_init
    assert_instance_of OpenEhr::RM::DataTypes::Basic::DvBoolean, @dv_boolean
    assert_instance_of OpenEhr::RM::DataTypes::Basic::DvState, @dv_state
    assert_instance_of OpenEhr::RM::DataTypes::Basic::DvIdentifier, @dv_identifier
  end

  def test_constant
    assert_equal("\r", OpenEhr::RM::DataTypes::Basic::DataValue::CR)
    assert_equal("\n", OpenEhr::RM::DataTypes::Basic::DataValue::LF)
  end

  def test_dv_boolean
    assert @dv_boolean.value?
    @dv_boolean.value = false
    assert !@dv_boolean.value?
    # inv: Value_exists
    assert_raise(ArgumentError){@dv_boolean.value=nil}
    assert_raise(ArgumentError){OpenEhr::RM::DataTypes::Basic::DvBoolean.new(nil)}
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
    assert_raise(ArgumentError) {OpenEhr::RM::DataTypes::Basic::DvState.new(nil,nil)}
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
    assert_raise(ArgumentError) {OpenEhr::RM::DataTypes::Basic::DvIdentifier.new(nil, nil, nil, nil)}
  end
end

# fixed
class RM_Data_Types_URI_Test < Test::Unit::TestCase
  def setup
    @dv_uri = OpenEhr::RM::DataTypes::Uri::DvUri.new("http://www.openehr.jp/changeset/test?cmd=93#file0")
    @dv_ehr_uri = OpenEhr::RM::DataTypes::Uri::DvEhrUri.new("ehr://1234567/87284370-2D4B-4e3d-A3F3-F303D2F4F34B@2005-08-02T04:30:00")
  end

  def test_init
    assert_instance_of OpenEhr::RM::DataTypes::Uri::DvUri, @dv_uri
    assert_instance_of OpenEhr::RM::DataTypes::Uri::DvEhrUri, @dv_ehr_uri
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
    assert_nothing_raised(Exception){@dv_text = OpenEhr::RM::DataTypes::Text::DvText.new("valid value")}
    @terminology_id = OpenEhr::RM::Support::Identification::TerminologyId.new('ICD10')
    
    assert_nothing_raised(Exception){@code_phrase = OpenEhr::RM::DataTypes::Text::CodePhrase.new('C92.0', @terminology_id)}
    assert_nothing_raised(Exception){@dv_coded_text = OpenEhr::RM::DataTypes::Text::DvCodedText.new("Acute Myeloid Leukemia", @code_phrase)}
    @dv_paragraph = OpenEhr::RM::DataTypes::Text::DvParagraph.new(Set.new(["test1", "test2"]))
    @term_mapping = OpenEhr::RM::DataTypes::Text::TermMapping.new('=',@dv_coded_text,"TEST")
  end

  def test_init
    assert_instance_of OpenEhr::RM::DataTypes::Text::DvText, @dv_text
    assert_instance_of OpenEhr::RM::DataTypes::Text::CodePhrase, @code_phrase
    assert_instance_of OpenEhr::RM::DataTypes::Text::DvCodedText, @dv_coded_text
    assert_instance_of OpenEhr::RM::DataTypes::Text::TermMapping, @term_mapping
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
    assert OpenEhr::RM::DataTypes::Text::TermMapping.is_valid_mach_code?('>')
    assert OpenEhr::RM::DataTypes::Text::TermMapping.is_valid_mach_code?('=')
    assert OpenEhr::RM::DataTypes::Text::TermMapping.is_valid_mach_code?('<')
    assert OpenEhr::RM::DataTypes::Text::TermMapping.is_valid_mach_code?('?')
    assert !OpenEhr::RM::DataTypes::Text::TermMapping.is_valid_mach_code?('!')
    assert_equal @dv_coded_text, @term_mapping.purpose
    assert_equal "TEST", @term_mapping.target
    assert_raise(ArgumentError){OpenEhr::RM::DataTypes::Text::TermMapping.new}
    assert_raise(ArgumentError){OpenEhr::RM::DataTypes::Text::TermMapping.new('!',@dv_coded_text, "invalid case")}
    assert_raise(ArgumentError){OpenEhr::RM::DataTypes::Text::TermMapping.new('=',nil , "invalid case")}
    assert_raise(ArgumentError){OpenEhr::RM::DataTypes::Text::TermMapping.new('=',@dv_coded_text, nil)}
  end
end

class QuantityTest < Test::Unit::TestCase
  def setup
    assert_nothing_raised(Exception){
      @dv_ordered = OpenEhr::RM::DataTypes::Quantity::DvOrdered.new }
    assert_nothing_raised(Exception){
      terminology = OpenEhr::RM::Support::Identification::TerminologyId.new('urine')
      code_phrase = OpenEhr::RM::DataTypes::Text::CodePhrase.new('protein',terminology)
      urinary_protein = OpenEhr::RM::DataTypes::Text::DvCodedText.new('+', code_phrase)
      @dv_ordinal1 = OpenEhr::RM::DataTypes::Quantity::DvOrdinal.new(1, urinary_protein)
      code_phrase = OpenEhr::RM::DataTypes::Text::CodePhrase.new('protein',terminology)
      urinary_protein = OpenEhr::RM::DataTypes::Text::DvCodedText.new('+++', code_phrase)
      @dv_ordinal2 = OpenEhr::RM::DataTypes::Quantity::DvOrdinal.new(3, urinary_protein)}
    assert_nothing_raised(Exception){
      @dv_interval = OpenEhr::RM::DataTypes::Quantity::DvInterval.new(@dv_ordinal1, @dv_ordinal2)}
    meaning = OpenEhr::RM::DataTypes::Text::DvText.new('normal')
    assert_nothing_raised(Exception){
      @reference_range = OpenEhr::RM::DataTypes::Quantity::ReferenceRange.new(meaning, @dv_interval)}
    assert_nothing_raised(Exception){
      @dv_quantified = OpenEhr::RM::DataTypes::Quantity::DvQuantified.new(1,'=')}
    assert_nothing_raised(Exception){
      @dv_amount = OpenEhr::RM::DataTypes::Quantity::DvAmount.new(2,'<')}
    assert_nothing_raised(Exception){
      @dv_quantity = OpenEhr::RM::DataTypes::Quantity::DvQuantity.new(3, 'mg', '~')}
    assert_nothing_raised(Exception){
      @dv_count = OpenEhr::RM::DataTypes::Quantity::DvCount.new(1)}
    assert_nothing_raised(Exception){
      @dv_proportion = OpenEhr::RM::DataTypes::Quantity::DvProportion.new(2,3,0)}
    assert_nothing_raised(Exception){
      @dv_absolute_quantity = OpenEhr::RM::DataTypes::Quantity::DvAbsoluteQuantity.new(7,'=')}
   end

   def test_init
     assert_instance_of OpenEhr::RM::DataTypes::Quantity::DvOrdered, @dv_ordered
     assert_instance_of OpenEhr::RM::DataTypes::Quantity::DvQuantified, @dv_quantified
     assert_instance_of OpenEhr::RM::DataTypes::Quantity::DvInterval, @dv_interval
     assert_instance_of OpenEhr::RM::DataTypes::Quantity::ReferenceRange, @reference_range
     assert_instance_of OpenEhr::RM::DataTypes::Quantity::DvOrdinal, @dv_ordinal1
     assert_instance_of OpenEhr::RM::DataTypes::Quantity::DvOrdinal, @dv_ordinal2
     assert_instance_of OpenEhr::RM::DataTypes::Quantity::DvQuantified, @dv_quantified
     assert_instance_of OpenEhr::RM::DataTypes::Quantity::DvAmount, @dv_amount
     assert_instance_of OpenEhr::RM::DataTypes::Quantity::DvQuantity, @dv_quantity
     assert_instance_of OpenEhr::RM::DataTypes::Quantity::DvCount, @dv_count
     assert_instance_of OpenEhr::RM::DataTypes::Quantity::DvProportion, @dv_proportion
     assert_instance_of OpenEhr::RM::DataTypes::Quantity::DvAbsoluteQuantity, @dv_absolute_quantity
  end

  def test_dv_ordered
    assert !@dv_ordered.is_normal?
    assert_nil @dv_ordered.normal_status
    assert_nil @dv_ordered.normal_range
    assert_nil @dv_ordered.other_refference_ranges
    assert @dv_ordered.is_simple?
    assert_raise(NotImplementedError){@dv_ordered<=>1}
    openehr_terminology_id = OpenEhr::RM::Support::Identification::TerminologyId.new('openEHR')
    normal_code = OpenEhr::RM::DataTypes::Text::CodePhrase.new('N', openehr_terminology_id)
    assert_equal 'N', normal_code.code_string
    assert_nothing_raised(Exception){
      @dv_ordered.normal_status = normal_code }
    assert @dv_ordered.is_normal?
    other = OpenEhr::RM::DataTypes::Quantity::DvOrdered.new
    assert_raise(NotImplementedError){
      @dv_ordered.is_strictly_comparable_to?(other)}
  end

  def test_dv_interval
    assert @dv_interval.lower < @dv_interval.upper
  end

  def test_reference_range
    assert_equal 'normal', @reference_range.meaning.value
    assert_equal 1, @reference_range.range.lower.value
    terminology = OpenEhr::RM::Support::Identification::TerminologyId.new('urine')
    code_phrase = OpenEhr::RM::DataTypes::Text::CodePhrase.new('protein',terminology)
    urinary_protein = OpenEhr::RM::DataTypes::Text::DvCodedText.new('++', code_phrase)
    dv_ordinal = OpenEhr::RM::DataTypes::Quantity::DvOrdinal.new(2, urinary_protein)
    assert @reference_range.is_in_range?(dv_ordinal)
    dv_ordinal.value = 6
    assert !@reference_range.is_in_range?(dv_ordinal)
  end

  def test_dv_quantified
    assert_equal 1, @dv_quantified.magnitude
    assert_equal '=', @dv_quantified.magnitude_status
    assert !OpenEhr::RM::DataTypes::Quantity::DvQuantified.valid_magnitude_status?('*')
    assert OpenEhr::RM::DataTypes::Quantity::DvQuantified.valid_magnitude_status?('>')
    assert OpenEhr::RM::DataTypes::Quantity::DvQuantified.valid_magnitude_status?('<')
    assert OpenEhr::RM::DataTypes::Quantity::DvQuantified.valid_magnitude_status?('>=')
    assert OpenEhr::RM::DataTypes::Quantity::DvQuantified.valid_magnitude_status?('<=')
    assert OpenEhr::RM::DataTypes::Quantity::DvQuantified.valid_magnitude_status?('~')
    assert_nothing_raised(Exception){@dv_quantified.magnitude = 0}
    assert_equal 0, @dv_quantified.magnitude
    assert_nothing_raised(Exception){@dv_quantified.magnitude_status = nil}
    assert_equal '=',  @dv_quantified.magnitude_status
  end

  def test_dv_absolute_quantity
    assert_equal 7, @dv_absolute_quantity.magnitude
    assert @dv_absolute_quantity.accuracy_unknown?
    assert_nothing_raised(Exception){@dv_absolute_quantity.accuracy = 0.5}
    assert_equal 0.5, @dv_absolute_quantity.accuracy
    assert !@dv_absolute_quantity.accuracy_unknown?
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
    meaning = OpenEhr::RM::DataTypes::Text::DvText.new('limits')
    limit_reference_range = OpenEhr::RM::DataTypes::Quantity::ReferenceRange.new(meaning, @dv_interval)
    assert_nothing_raised(Exception){@dv_ordinal1.limits = limit_reference_range}
    assert_equal 'limits', @dv_ordinal1.limits.meaning.value
  end

  def test_dv_quantity
    assert_equal 3, @dv_quantity.magnitude
    assert_equal 'mg', @dv_quantity.units
    assert_equal '~', @dv_quantity.magnitude_status
    dv_quantity2 = OpenEhr::RM::DataTypes::Quantity::DvQuantity.new(4, 'mg', '~')
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
    dv_count2 = OpenEhr::RM::DataTypes::Quantity::DvCount.new(2)
    dv_count3 = @dv_count + dv_count2
    assert 3, dv_count3.magnitude
    dv_count3 = dv_count2 - @dv_count
    assert 1, dv_count3.magnitude
  end

  def test_proportion_kind
    assert_equal 0, OpenEhr::RM::DataTypes::Quantity::ProportionKind::PK_RATIO
    assert_equal 1, OpenEhr::RM::DataTypes::Quantity::ProportionKind::PK_UNITARY
    assert_equal 2, OpenEhr::RM::DataTypes::Quantity::ProportionKind::PK_PERCENT
    assert_equal 3, OpenEhr::RM::DataTypes::Quantity::ProportionKind::PK_FRACTION
    assert_equal 4, OpenEhr::RM::DataTypes::Quantity::ProportionKind::PK_INTEGER_FRACTION
    assert OpenEhr::RM::DataTypes::Quantity::ProportionKind.valid_proportion_kind?(0)
    assert OpenEhr::RM::DataTypes::Quantity::ProportionKind.valid_proportion_kind?(4)
    assert !OpenEhr::RM::DataTypes::Quantity::ProportionKind.valid_proportion_kind?(-1)
    assert !OpenEhr::RM::DataTypes::Quantity::ProportionKind.valid_proportion_kind?(5)
  end

  def test_dv_proportion
    assert_equal 2.0, @dv_proportion.numerator
    assert_equal 3.0, @dv_proportion.denominator
    assert_equal 0, @dv_proportion.type
    assert_equal 2.0/3.0, @dv_proportion.magnitude
    assert @dv_proportion.is_integral?
    dv_proportion2 = OpenEhr::RM::DataTypes::Quantity::DvProportion.new(1,3,0)
    assert @dv_proportion.is_strictly_comparable_to?(dv_proportion2)
    dv_proportion2 = OpenEhr::RM::DataTypes::Quantity::DvProportion.new(1,3,4)
    assert !@dv_proportion.is_strictly_comparable_to?(dv_proportion2)
    assert_raise(ArgumentError){
      dv_proportion2 = OpenEhr::RM::DataTypes::Quantity::DvProportion.new(1.5,2.3,3)}
    assert_raise(ArgumentError){
      dv_proportion2 = OpenEhr::RM::DataTypes::Quantity::DvProportion.new(10,10,1)}
    assert_nothing_raised(Exception){
      dv_proportion2 = OpenEhr::RM::DataTypes::Quantity::DvProportion.new(10,1,1)}
    assert_raise(ArgumentError){
      dv_proportion2 = OpenEhr::RM::DataTypes::Quantity::DvProportion.new(10,10,2)}
    assert_nothing_raised(Exception){
      dv_proportion2 = OpenEhr::RM::DataTypes::Quantity::DvProportion.new(10,100,2)}
  end

end

class EncapsulatedTest < Test::Unit::TestCase
  def setup
    charset = OpenEhr::RM::DataTypes::Text::CodePhrase.new('UTF-8','character-sets')
    language = OpenEhr::RM::DataTypes::Text::CodePhrase.new('ja', 'languages')
    assert_nothing_raised(Exception){
      @dv_encapsulated = OpenEhr::RM::DataTypes::Encapsulated::DvEncapsulated.new(charset, language, 10)}
    assert_nothing_raised(Exception){
      @dv_parsable = OpenEhr::RM::DataTypes::Encapsulated::DvParsable.new(charset, language, 10, 'XML','<TEST>test</TEST>')}
    media_type = OpenEhr::RM::DataTypes::Text::CodePhrase.new('text/html', 'media-types')
    uri = OpenEhr::RM::DataTypes::Uri::DvUri.new("http://www.openehr.jp/changeset/test?cmd=93#file0")
    assert_nothing_raised(Exception){
      @dv_multimedia = OpenEhr::RM::DataTypes::Encapsulated::DvMultimedia.new(charset, language, 10, media_type, uri)}
  end

  def test_init
    assert_instance_of OpenEhr::RM::DataTypes::Encapsulated::DvEncapsulated, @dv_encapsulated
    assert_instance_of OpenEhr::RM::DataTypes::Encapsulated::DvParsable, @dv_parsable
    assert_instance_of OpenEhr::RM::DataTypes::Encapsulated::DvMultimedia, @dv_multimedia
  end

  def test_dv_encapsulated
    assert_equal 'UTF-8', @dv_encapsulated.charset.code_string
    assert_equal 'ja', @dv_encapsulated.language.code_string
    assert_equal 10, @dv_encapsulated.size
    wrong_charset = OpenEhr::RM::DataTypes::Text::CodePhrase.new('USO8000', 'character-sets')
    assert_raise(ArgumentError){@dv_encapsulated.charset = wrong_charset}
    charset = OpenEhr::RM::DataTypes::Text::CodePhrase.new('EUC-JP', 'character-sets')
    assert_nothing_raised(Exception){@dv_encapsulated.charset = charset}
    assert_equal 'EUC-JP', @dv_encapsulated.charset.code_string
    wrong_language = OpenEhr::RM::DataTypes::Text::CodePhrase.new('jpg', 'language')
    assert_raise(ArgumentError){@dv_encapsulated.language = wrong_language}
    language = OpenEhr::RM::DataTypes::Text::CodePhrase.new('eng', 'language')
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


class TestDvTimeSpecification < Test::Unit::TestCase
  include OpenEhr::RM::DataTypes::TimeSpecification
  include OpenEhr::RM::DataTypes::Encapsulated
  def setup
    charset = OpenEhr::RM::DataTypes::Text::CodePhrase.new('UTF-8','character-sets')
    language = OpenEhr::RM::DataTypes::Text::CodePhrase.new('ja', 'languages')
    assert_nothing_raised(Exception){
      dv_parsable = DvParsable.new(charset, language, 10, 'XML','<TEST>test</TEST>')
      @dv_time_specification = DvTimeSpecification.new(dv_parsable)}
#    assert_nothing_raised(Exception){
#      @dv_periodic_time_specification = DV_Periodic_Time_Specification.new('[200004181100;200004181110]/(7d)@DWIST', charset, language, 10, 'HL7:PIVL')}
  end

  def test_init
    assert_instance_of DvTimeSpecification, @dv_time_specification
  end

  def test_dv_time_specification
    assert_equal '<TEST>test</TEST>', @dv_time_specification.value.value
  end
end
