require 'rexml/document'
require 'builder'

module OpenEHR
  module Serializer
    NL = "\r\n"
    INDENT = '    '

    class BaseSerializer
      def initialize(archetype)
        @archetype = archetype
      end

      def serialize
        return self.merge
      end
    end

    class ADLSerializer < BaseSerializer
      def header
        hd = 'archetype'
        unless @archetype.adl_version.nil?
          hd << " (adl_version = #{@archetype.adl_version})"
        end
        hd << NL+INDENT + "#{@archetype.archetype_id.value}"+NL*2
        hd << 'concept'+NL+ INDENT+"[#{@archetype.concept}]"+NL
        hd << NL+'language'+NL+INDENT+'original_language = <['+
          @archetype.original_language.terminology_id.value+'::'+
          @archetype.original_language.code_string+']>'+NL
        return hd
      end

      def description
        desc = ''
        if @archetype.description
          ad = @archetype.description
          desc << 'description' + NL
          desc << INDENT + 'original_author = <' + NL
          ad.original_author.each do |k,v|
            desc << INDENT+INDENT+'["'+k+'"] = <"'+v+'">'+NL
          end
          desc << INDENT+'>'+NL
          desc << INDENT+'lifecycle_state = <"'+ad.lifecycle_state+'">'+NL
          desc << INDENT+'details = <'+NL
          ad.details.each do |lang,item|
            desc << INDENT*2+'["'+lang+'"] = <'+NL
            desc << INDENT*3+'language = <['+
              item.language.terminology_id.value+'::'+
              item.language.code_string+']>'+NL
            desc << INDENT*3+'purpose = <"'+item.purpose+'">'+NL
            if item.keywords then
              desc << INDENT*3+'keywords = <'
              item.keywords.each do |word|
                desc << '"'+word+'",'
              end
              desc.chop! << '>'+NL
            end
            desc << INDENT*3+'use = <"'+item.use+'">'+NL if item.use
            desc << INDENT*3+'misuse = <"'+item.misuse+'">'+NL if item.misuse
            desc << INDENT*3+'copyright = <"'+item.copyright+'">'+NL if item.copyright
            if item.original_resource_uri
              desc << INDENT*3 + 'original_resource_uri = <'
              item.original_resource_uri.each do |k,v|
                desc << INDENT*4+'["'+k+'"] = <"'+v+'">'+NL
              end
              desc << INDENT*3+'>'+NL
            end
            if item.other_details
              desc << INDENT*3 + 'other_details = <'
              item.original_resource_uri.each do |k,v|
                desc << INDENT*4+'["'+k+'"] = <"'+v+'">'+NL
              end
              desc << INDENT*3+'>'+NL
            end
            desc << INDENT*2+'>'+NL
          end
          desc << INDENT+'>'+NL
        end
        return desc
      end

      def definition
        ad = @archetype.definition
        definition = 'definition'+NL
        definition << INDENT+ad.rm_type_name+"[#{ad.node_id}] matches {"
        if ad.any_allowed?
          definition << '*}'+NL
        else
          definition << NL
          if ad.attributes
            attributes = ad.attributes
            indents = 2
            while attributes
              definition << INDENT*indents+attributes.rm_type_name
              definition << "[#{attributes.node_id}] "
              definition << existence(attributes.existence)
              definition << " matches {"
            end
          end
        end
      end

      def ontology
        ao = @archetype.ontology
        ontology = 'ontology'+NL
        ontology << INDENT + 'term_definitions = <' + NL
        ao.term_codes.each do |term, items|
          ontology << INDENT*2 + "[\"#{term}\"] = <" + NL
          ontology << INDENT*3 + 'items = <'  + NL
          items.each do |code, attribute|
            ontology << INDENT*4 + "[\"#{code}\] = <" + NL
            terms.each do |name, description|
              ontology << INDENT*5 + "#{name} = <\"#{description}\">" +NL
            end
            ontology << INDENT*4 + '>'+NL
          end
          ontogoly << INDENT*3 + '>' + NL
          ontology << INDENT*2 + '>' + NL
        end
        ontology << INDENT + '>' + NL
      end

      def envelope
      end

      def merge
        return header + description + definition + ontology
      end

      private
      def c_object
      end

      def existence(existence)
        "existence matches {#{existence.lower}..#{existence.upper}}"
      end
    end

    class XMLSerializer < BaseSerializer

      def header
        header = ''
        xml = Builder::XmlMarkup.new(:indent => 2, :target => header)
        xml.archetype_id do 
          xml.value @archetype.archetype_id.value
        end
        xml.concept @archetype.concept
        xml.original_language do
          xml.terminology_id do
            xml.value @archetype.original_language.terminology_id.value
          end
          xml.code_string @archetype.original_language.code_string
        end
        return header
      end

      def description
        desc = ''
        xml = Builder::XmlMarkup.new(:indent => 2, :target => desc)
        ad = @archetype.description
        if ad
          xml.description do
            ad.original_author.each do |key,value|
              xml.original_author(value,"id"=>key)
            end
            if ad.other_contributors
              ad.other_contributors.each do |co|
                xml.other_contributors co
              end
            end
            xml.lifecycle_state ad.lifecycle_state
            xml.details do
              ad.details.each do |lang, item|
                xml.language do
                  xml.terminology_id do
                    xml.value item.language.terminology_id.value
                  end
                  xml.code_string lang
                end
                xml.purpose item.purpose
                if item.keywords then
                  item.keywords.each do |word|
                    xml.keywords word
                  end
                end
                xml.use item.use if item.use
                xml.misuse item.misuse if item.misuse
                xml.copyright item.copyright if item.copyright
                if ad.other_details
                  ad.other_details.each do |key,value|
                    xml.other_details(value, "id"=>key)
                  end
                end
              end
            end
          end
        end
        return desc
      end

      def definition
        definition = ''
        ad = @archetype.definition
        xml = Builder::XmlMarkup.new(:indent => 2, :target => definition)
        xml.definition do
          xml.rm_type_name ad.rm_type_name
          xml.occurrence do
            oc = ad.occurrences
            xml.lower_included oc.lower_included? unless oc.lower_included?.nil?
            xml.upper_included oc.upper_included? unless oc.upper_included?.nil?
            xml.lower_unbounded oc.lower_unbounded?
            xml.upper_unbounded oc.upper_unbounded?
            xml.lower oc.lower
            xml.upper oc.lower
          end
          xml.node_id ad.node_id
        end
      end

      def merge

      end
    end
  end
end

class Publisher
  def initialize(serializer)
    @serializer = serializer
  end

  def publish(writer)
    writer.out(@serializer.serialize)
  end
end

class Writer
  def initialize(target)
    @target = target
  end
  def out
  end
end
