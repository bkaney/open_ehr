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
          def ==(object_id)
            @value == object_id.value
          end
        end # of ObjectID

        class Object_Ref
          attr_reader :namespace, :type, :id

          def initialize(namespace, type, id)
            self.namespace = namespace
            self.type = type
            self.id = id
          end

          def namespace=(namespace)
            raise ArgumentError if namespace.nil? or namespace.empty? or !(/([a-z]|[A-Z]).*/ =~ namespace) # error original is =~ #([a-z][A-Z])([a-z]|[A-Z]|\s|[0-9]|[_-\:\/\&\+\?])*/
            @namespace = namespace
          end

          def type=(type)
            raise ArgumentError if type.nil? or type.empty?
            @type = type
          end

          def id=(id)
            raise ArgumentError if id.nil?
            @id = id
          end
        end
        
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
          attr_reader :name, :version_id

          def initialize(value, name , version_id="")
            super(value)
            self.name = name
            self.version_id = version_id
          end

          def name=(name)
            raise ArgumentError, "name not valid" if name.nil? or name.empty?
            @name = name
          end

          def version_id=(version_id)
            raise ArgumentError, "version_id not valid" if version_id.nil?
            @version_id = version_id
          end
        end # of Terminology_ID

        class Generic_ID < Object_ID
          attr_reader :scheme

          def initialize(value, scheme)
            super(value)
            self.scheme = scheme
          end

          def scheme=(scheme)
            raise ArgumentError, "scheme not valid" if scheme.nil? or scheme.empty?
            @scheme = scheme
          end
        end # of Generic_ID

        class UID_Based_ID < Object_ID
          def initialize(value)
            super(value)
          end
          def extension
            if self.has_extension?
              @value[/::.*/][2..-1]
            else
              ''
            end
          end
          def has_extension?
            @value.include? '::'
          end
          def root
            if self.has_extension?
              @value[/.*::/][0..-3]
            else
              @value
            end
          end
        end
      end # of Identification
    end # of Support
  end # of RM
end # of OpenEHR
