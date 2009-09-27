require 'test/unit'

TEST_ROOT_DIR = File.dirname(__FILE__)
$LOAD_PATH << File.join(TEST_ROOT_DIR, '..', 'lib')
require "rubygems"
require 'adl_parser.rb'
#require 'adl_scanner.rb'
#require 'open_ehr'
#require 'rm.rb'
#require 'am.rb'


# c.f. "Ruby Best Practice",p.75
module Test::Unit
  class TestCase
    def self.must(name, &block)
      test_name = "test_#{name.gsub(/\s+/,'_')}".to_sym
      defined = instance_method(test_name) rescue false
      raise "#{test_name} is already defined in #{self}" if defined
      if block_given?
        define_method(test_name, &block)
      else
        define_method(test_name) do
          flunk "No implementation provided for #{name}"
        end
      end
    end
  end
end
