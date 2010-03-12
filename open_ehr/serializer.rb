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
        hd << NL+INDENT + "#{@archetype.archetype_id.value}"+NL+NL
        hd << 'concept'+NL+ INDENT+"[#{@archetype.concept}]"+NL
        hd << NL+'language'+NL+INDENT+'original_language = <['+
          @archetype.original_language.terminology_id.value+'::'+
          @archetype.original_language.code_string+']>'+NL
        return hd
      end

      def description

      end

      def definition
      end

      def ontology
      end

      def envelope
      end

      def merge
        return header + description + definition + ontology
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
          xml.code_string @archetype.original_language.code_string
          xml.terminology_id do
            xml.value @archetype.original_language.terminology_id.value
          end
        end
        return header
      end

      def description
        
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
