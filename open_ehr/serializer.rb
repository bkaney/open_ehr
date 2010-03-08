require 'rexml/document'

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
      def description
        return <<HERE
archetype (adl_version = #{@archetype.adl_version})
     #{@archetype.archetype_id.value}
HERE
      end

      def definition
      end

      def ontology
      end

      def envelope
      end

      def merge
        return description + definition + ontology
      end
    end

    class XMLSerializer < BaseSerializer
      def description
        desc = REXML::Element.new('archetype_id').
          add_text(@archetype.archetype_id.value)
        return desc
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
end
