#$:.unshift File.join(File.dirname(__FILE__))

require 'lib/dparser.rb'
require 'test/unit'

class DADLParserTest < Test::Unit::TestCase
  def setup
    @parser = ::OpenEHR::DADLParser.new
  end

  def test_init
    assert_instance_of ::OpenEHR::DADLParser,@parser
  end

  def test_parse
    dadl_line_break = File.read('tests/dadl_line_break.dadl')
    assert_nothing_raised do
      @parser.parse(dadl_line_break, 'dadl_line_break')
    end
  end

end
