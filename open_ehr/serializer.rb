require 'rexml/document'
require 'builder'

module OpenEHR
  module Serializer
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
        return <<HERE
archetype (adl_version = #{@archetype.adl_version})
\t#{@archetype.archetype_id.value}

concept
\t[#{@archetype.concept}]
HERE
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
