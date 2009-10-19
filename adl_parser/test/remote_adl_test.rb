require File.dirname(__FILE__) + '/test_helper.rb'

class RemoteADLTest < Test::Unit::TestCase
  def setup
    @ehr_adls = []
    ehr_dirs = ["cluster", "composition", "element", "entry", "section", "structure"]
    ehr_dirs.each do |dir|
      doc = Hpricot( open("http://www.openehr.org/svn/knowledge/archetypes/dev/adl/openehr/ehr/#{dir}").read )
      (doc/:a).each do |link|
        if link[:href] =~ /.*\.adl\Z/
          @ehr_adls << "http://www.openehr.org/svn/knowledge/archetypes/dev/adl/openehr/ehr/#{dir}/#{$~}"
        end
      end
    end

    @test_adls = []
    test_dirs = ["basics","clinical_types","dadl","description","generic_types","language","non-conforming","paths","rm_checking","slots","specialisation","structure","terminology","unicode","validation"]
    test_dirs.each do |dir|
      doc = Hpricot( open("http://www.openehr.org/svn/knowledge/archetypes/dev/adl/test/#{dir}").read )
      (doc/:a).each do |link|
        if link[:href] =~ /.*\.adl\Z/
          @test_adls << "http://www.openehr.org/svn/knowledge/archetypes/dev/adl/test/#{dir}/#{$~}"
        end
      end
    end
    @parser = ::OpenEhr::ADL::Parser.new
  end


#   must "test_adls should properly parsed" do
#     assert_nothing_raised do
#       @test_adls.each do |adl|
#         puts "Processing #{adl}"
#         open(adl) do |file|
#           p "Processing #{file.gets}"
#           case file.gets
#           when "http://www.openehr.org/svn/knowledge/archetypes/dev/adl/test/basics/adl-test-ENTRY.basic_types_fail.v1.adl"
#             assert_raise Racc::ParserError do 
#               @parser.parse(file.read, adl)
#             end
#           else
#             assert_nothing_raised { @parser.parse(file.read, adl) }
#           end
#         end
#       end
#     end
#   end

  must "ehr_adls should properly parsed" do
    assert_nothing_raised do
      @ehr_adls.each do |adl|
        puts "Processing #{adl}"
        open(adl) do |file|
          assert_nothing_raised do
            @parser.parse(file.read, adl)
          end
        end
      end
    end
  end


end
