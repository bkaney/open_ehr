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
            raise "empty value" if value.nil? or value.empty?
            @value = value            
          end
        end # of ObjectID
        
        class Archetype_ID < Object_ID
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
