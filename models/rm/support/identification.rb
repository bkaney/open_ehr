# This module is an implementation of this UML:
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_0_76d0249_1109331021343_528780_2066Report.html
# Ticket refs #39
module OpenEHR
  module RM
    module Support
      module Identification

        class Object_ID
          attr_reader :value

          def initialize(value)
            self.value=value
          end

          def value=(value)
            raise ArgumentError, "empty value" if value.nil? or value.empty?
            @value = value            
          end
        end # of ObjectID
        
        class Archetype_ID < Object_ID
          attr_reader :domain_concept, :rm_name, :rm_entity, :rm_originator, :specialisation, :version_id

          def initialize(value, domain_concept, rm_name, rm_entity, rm_originator, specialisation, version_id)
            super(value)
            self.domain_concept = domain_concept
            self.rm_name = rm_name
            self.rm_entity = rm_entity
            self.rm_originator = rm_originator
            self.specialisation = specialisation
            self.version_id = version_id
          end

          def domain_concept=(domain_concept)
            raise ArgumentError, "domain concept not valid" if domain_concept.nil? or domain_concept.empty?
            @domain_concept = domain_concept
          end

          def rm_name=(rm_name)
            raise ArgumentError, "rm_name not valid" if rm_name.nil? or rm_name.empty?
            @rm_name = rm_name
          end

          def rm_entity=(rm_entity)
            raise ArgumentError, "rm_entity not valid" if rm_entity.nil? or rm_entity.empty?
            @rm_entity = rm_entity
          end

          def rm_originator=(rm_originator)
            raise ArgumentError, "rm_originator not valid" if rm_originator.nil? or rm_originator.empty?
            @rm_originator = rm_originator
          end

          def specialisation=(specialisation)
            raise ArgumentError, "rm_specialisation not valid" if specialisation.nil? or specialisation.empty?
            @specialisation = specialisation
          end
          def version_id=(version_id)
            raise ArgumentError, "version_id not valid" if version_id.nil? or version_id.empty?
            @version_id = version_id
          end
        end

        class Terminology_ID < Object_ID
          attr_reader :name

          def initialize(name , version_id)
            @name , @version_id = name , version_id
          end

          def setValue(value)
            loadValue(value)
            super.value = value
          end

          def version_id
            @version
          end

          private

          def loadValue(value)
            if /\(.*\)$/ =~ value
#              @name, @version = value.split(\())
              @version.chop!
            else
              @name = value
              @version = nil
            end
          end

          def toValue(name, version)
            if name == ""
              raise Exception.new("empty name")
            end
            name + (version == nil ? "" : "(" + version + ")")
          end
        end # of Terminology_ID
      end # of Definition
    end # of Support
  end # of RM
end # of OpenEHR
