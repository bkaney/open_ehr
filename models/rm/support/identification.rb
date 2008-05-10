module OpenEHR
  module RM
    module Support
      module Identification

        class OBJECT_ID
          attr_accessor :value

          def initiallize(value)
            raise "empty value" unless value
            @value = value
          end
        end # of ObjectID

        class ARCHETYPE_ID < OBJECT_ID
        end

        class TERMINOLOGY_ID < OBJECT_ID
          attr_reader :name

          def initialize(name , version_id)
            @name , @version_id = name , version_id
#             if arg1 == nil
#               super(arg0)
#             else
#               super(toValue(arg0, arg1))
#               @name = arg0
#               @version = arg1      
#             end
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
        end # of TerminologyID
      end # of Definition
    end # of Support
  end # of RM
end # of OpenEHR
