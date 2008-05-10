require 'lib/scanner.rb'
require 'test/unit'

class YaparcParserTest < Test::Unit::TestCase
  def test_RootScanner
    parser = OpenEHR::ADL::Scanner::DADL::RootScanner.new
    assert_instance_of OpenEHR::ADL::Scanner::DADL::RootScanner,parser
    result = parser.parse('')
  end

  def test_V_LOCAL_TERM_CODE_REF
    parser = OpenEHR::ADL::Scanner::Common::V_LOCAL_TERM_CODE_REF.new
    assert_instance_of OpenEHR::ADL::Scanner::Common::V_LOCAL_TERM_CODE_REF,parser
    result = parser.parse('[en-us]')
    assert_instance_of Yaparc::Result::OK, result
  end

  def test_V_QUALIFIED_TERM_CODE_REF
    parser = OpenEHR::ADL::Scanner::Common::V_QUALIFIED_TERM_CODE_REF.new
    assert_instance_of OpenEHR::ADL::Scanner::Common::V_QUALIFIED_TERM_CODE_REF,parser
    result = parser.parse('[ISO_639::en]')
    assert_instance_of Yaparc::Result::OK, result
    result = parser.parse('[ISO_639::en-us]')
    assert_instance_of Yaparc::Result::OK, result
  end

  def test_V_STRING
    parser = OpenEHR::ADL::Scanner::Common::V_STRING.new
    assert_instance_of OpenEHR::ADL::Scanner::Common::V_STRING,parser
    result = parser.parse('"this is a string"')
    assert_instance_of Yaparc::Result::OK, result
    result = parser.parse('"en-us"')
    assert_instance_of Yaparc::Result::OK, result
  end

  def test_V_REAL
    parser = OpenEHR::ADL::Scanner::Common::V_REAL.new
    assert_instance_of OpenEHR::ADL::Scanner::Common::V_REAL,parser
    result = parser.parse('0.1')
    assert_instance_of Yaparc::Result::OK, result
    result = parser.parse('0.0..20000.0')
    assert_instance_of Yaparc::Result::OK, result
    assert_equal [:V_REAL, "0.0"], result.value
    assert_equal "..20000.0", result.input
  end

  def test_V_ISO8601_DURATION
    parser = OpenEHR::ADL::Scanner::Common::V_ISO8601_DURATION.new
    assert_instance_of OpenEHR::ADL::Scanner::Common::V_ISO8601_DURATION,parser
    result = parser.parse('PT1M')
    assert_instance_of Yaparc::Result::OK, result
    result = parser.parse('PYMWDTHMS')
    assert_instance_of Yaparc::Result::OK, result
    assert_equal [:V_ISO8601_DURATION, "PYMWDTHMS"], result.value
  end

  def test_V_ISO8601_DATE_TIME_CONSTRAINT_PATTERN
    parser = OpenEHR::ADL::Scanner::CADL::V_ISO8601_DATE_TIME_CONSTRAINT_PATTERN.new
    assert_instance_of OpenEHR::ADL::Scanner::CADL::V_ISO8601_DATE_TIME_CONSTRAINT_PATTERN,parser
    result = parser.parse('yyyy-??-??T??:??:??')
    assert_instance_of Yaparc::Result::OK, result
  end

  def test_V_ISO8601_DATE_CONSTRAINT_PATTERN
    parser = OpenEHR::ADL::Scanner::CADL::V_ISO8601_DATE_CONSTRAINT_PATTERN.new
    assert_instance_of OpenEHR::ADL::Scanner::CADL::V_ISO8601_DATE_CONSTRAINT_PATTERN,parser
    result = parser.parse('yyyy-mm-XX-dd')
    assert_instance_of Yaparc::Result::OK, result
  end

  def test_V_ISO8601_TIME_CONSTRAINT_PATTERN
    parser = OpenEHR::ADL::Scanner::CADL::V_ISO8601_TIME_CONSTRAINT_PATTERN.new
    assert_instance_of OpenEHR::ADL::Scanner::CADL::V_ISO8601_TIME_CONSTRAINT_PATTERN,parser
    result = parser.parse('hh:mm:ss:??')
    assert_instance_of Yaparc::Result::OK, result
  end

  def test_dadl_reserved
    parser = OpenEHR::ADL::Scanner::DADL::RootScanner.new
    result = parser.parse('then')
    assert_instance_of Yaparc::Result::OK, result
    result = parser.parse('infinity')
    assert_instance_of Yaparc::Result::OK, result
    assert_equal [:SYM_INFINITY, :SYM_INFINITY], result.value
  end

  def test_cadl
    parser = OpenEHR::ADL::Scanner::CADL::RootScanner.new
    assert_instance_of OpenEHR::ADL::Scanner::CADL::RootScanner,parser
    result = parser.parse('PT1M')
    assert_instance_of Yaparc::Result::OK, result
    assert_equal [:V_ISO8601_DURATION, "PT1M"], result.value
    result = parser.parse('PYMWDTHMS')
    assert_instance_of Yaparc::Result::OK, result
    assert_equal [:V_ISO8601_DURATION, "PYMWDTHMS"], result.value
  end

  def test_cadl_reserved
    parser = OpenEHR::ADL::Scanner::CADL::RootScanner.new
    result = parser.parse('then')
    assert_instance_of Yaparc::Result::OK, result
    result = parser.parse('cardinality')
    assert_instance_of Yaparc::Result::OK, result
    assert_equal [:SYM_CARDINALITY, :SYM_CARDINALITY], result.value
    result = parser.parse('ordered')
    assert_instance_of Yaparc::Result::OK, result
    assert_equal "", result.input
    assert_equal [:SYM_ORDERED, :SYM_ORDERED], result.value
  end

  
end
