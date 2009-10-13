require File.dirname(__FILE__) + '/test_helper.rb'

class RemoteADLTest < Test::Unit::TestCase
  def setup
    @adls = []
    dirs = ["cluster/", "composition/", "element/", "entry/", "section/", "structure/"]
    dirs.each do |dir|
      doc = Hpricot( open("http://www.openehr.org/svn/knowledge/archetypes/dev/adl/openehr/ehr/#{dir}").read )
      (doc/:a).each do |link|
        if link[:href] =~ /.*\.adl\Z/
          @adls << "http://www.openehr.org/svn/knowledge/archetypes/dev/adl/openehr/ehr/#{dir}#{$~}"
        end
      end
    end
    @parser = ::OpenEhr::ADL::Parser.new
  end

  must "adls should properly parsed" do
    assert_nothing_raised do
      @adls.each do |adl|
        puts "Processing #{adl}"
        open(adl) do |file|
          @parser.parse(file.read, adl)
        end
      end
    end
  end

end
