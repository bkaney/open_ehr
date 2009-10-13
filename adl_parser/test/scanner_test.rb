require File.dirname(__FILE__) + '/test_helper.rb'

class ADLScannerTest < Test::Unit::TestCase
  def setup
    @scanner = OpenEhr::ADL::Scanner::ADLScanner.new([:adl], "filename")
  end

  must "assert OpenEhr::ADL::Scanner::ADLScanner scanner instance" do
    assert_instance_of OpenEhr::ADL::Scanner::ADLScanner, @scanner
  end

  must "assert ADLScanner scanner scan CR and lineno incremented" do
    lineno = @scanner.lineno
    @scanner.scan("\n")
    assert_equal lineno+1, @scanner.lineno
  end

  must "assert ADLScanner scanner scan ARCHETYPE_ID" do
    lineno = @scanner.lineno
    @scanner.scan("openEHR-EHR-OBSERVATION.body_mass_index.v1") do |sym, val|
      assert_equal :V_ARCHETYPE_ID,sym
      assert_instance_of OpenEhr::RM::Support::Identification::ArchetypeID,val
    end
  end

  must "assert ADLScanner scanner scan white space and lineno unchanged" do
    lineno = @scanner.lineno
    @scanner.scan(" ")
    assert_equal lineno, @scanner.lineno
  end

  must "assert ADLScanner scanner scan V_QUALIFIED_TERM_CODE_REF" do
    @scanner.scan("[ICD10AM(1998)::F23]") do |sym, val|
      assert_equal :V_QUALIFIED_TERM_CODE_REF,sym
      assert_equal "ICD10AM(1998)::F23",val
    end
  end

  must "assert ADLScanner scanner scan V_STRING" do
    @scanner.scan("\"string\"") do |sym, val|
      assert_equal :V_STRING,sym
      assert_equal "string",val
    end
    @scanner.scan("\"1605E211E9BFB4093A72CCE7A9792FF9\"") do |sym, val|
      assert_equal :V_STRING,sym
      assert_equal "1605E211E9BFB4093A72CCE7A9792FF9",val
    end
  end
end

class CADLScannerTest < Test::Unit::TestCase
  def setup
    @scanner = OpenEhr::ADL::Scanner::CADLScanner.new([:cadl], "filename")
  end

  must "assert OpenEhr::ADL::Scanner::CADLScanner scanner instance" do
    assert_instance_of OpenEhr::ADL::Scanner::CADLScanner, @scanner
  end

  must "assert CADLScanner scanner scan V_ATTRIBUTE_IDENTIFIER" do
    lineno = @scanner.lineno
    @scanner.scan("identifier") do |sym, val|
      assert_equal :V_ATTRIBUTE_IDENTIFIER, sym
      assert_equal "identifier", val
    end
    assert_equal lineno, @scanner.lineno
  end

  must "assert CADLScanner scanner scan reserved words" do
    lineno = @scanner.lineno
    @scanner.scan("then") do |sym, val|
      assert_equal :SYM_THEN, sym
    end
  end

  must "assert CADLScanner scanner scan V_QUALIFIED_TERM_CODE_REF" do
    @scanner.scan("[ICD10AM(1998)::F23]") do |sym, val|
      assert_equal :V_QUALIFIED_TERM_CODE_REF,sym
      assert_equal "ICD10AM(1998)::F23",val
    end
  end

  must "assert CADLScanner scanner scan V_ISO8601_DURATION" do
    @scanner.scan("PT1M") do |sym, val|
      assert_equal :V_ISO8601_DURATION,sym
      assert_equal "PT1M",val
    end
  end

  must "assert CADLScanner scanner scan V_STRING" do
    @scanner.scan("\"string\"") do |sym, val|
      assert_equal :V_STRING,sym
      assert_equal "string",val
    end
    @scanner.scan("\"1605E211E9BFB4093A72CCE7A9792FF9\"") do |sym, val|
      assert_equal :V_STRING,sym
      assert_equal "1605E211E9BFB4093A72CCE7A9792FF9",val
    end
  end

  must "assert CADLScanner scanner scan V_ISO8601_DURATION_CONSTRAINT_PATTERN" do
    @scanner.scan("PW") do |sym, val|
      assert_equal :V_ISO8601_DURATION_CONSTRAINT_PATTERN,sym
      assert_equal "PW",val
    end
  end
end

class DADLScannerTest < Test::Unit::TestCase
  def setup
    @scanner = OpenEhr::ADL::Scanner::DADLScanner.new([:dadl], "filename")
  end

  must "assert DADLScanner scanner scan V_QUALIFIED_TERM_CODE_REF" do
    @scanner.scan("[ICD10AM(1998)::F23]") do |sym, val|
      assert_equal :V_QUALIFIED_TERM_CODE_REF,sym
      assert_equal "ICD10AM(1998)::F23",val
    end
  end

  must "assert DADLScanner scanner scan V_ISO8601_EXTENDED_DATE" do
    @scanner.scan("2005-10-10") do |sym, val|
      assert_equal :V_ISO8601_EXTENDED_DATE,sym
      assert_equal "2005-10-10",val
    end
  end

  must "assert DADLScanner scanner scan V_STRING" do
    @scanner.scan("\"string\"") do |sym, val|
      assert_equal :V_STRING,sym
      assert_equal "string",val
    end

    @scanner.scan("\"2005-10-10\"") do |sym, val|
      assert_equal :V_STRING,sym
      assert_equal "2005-10-10",val
    end

    @scanner.scan("\"1605E211E9BFB4093A72CCE7A9792FF9\"") do |sym, val|
      assert_equal :V_STRING,sym
      assert_equal "1605E211E9BFB4093A72CCE7A9792FF9",val
    end
  end

  must "assert DADLScanner scanner scan V_URI" do
    @scanner.scan("http://openEHR.org/Services") do |sym, val|
      assert_equal :V_URI,sym
      assert_equal "http://openEHR.org/Services",val
    end
  end
end
