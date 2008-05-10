module OpenEHR
  module RM
    module Data_Types
      module Basic
        module Canonical_Fragment
        end

        class Data_Value
          include OpenEHR::RM::Support::Definition::Basic_Definition
        end

        class DV_Boolean < Data_Value
          def initialize(value)
            check_not_nil(value)
            if value == "TRUE" or value == true
              @value = true
            else
              @value = false
            end
          end
          def value=(value)
            check_not_nil(value)
            @value = value
          end
          def value?
            @value == true
          end
          private
          def check_not_nil(value)
            if value == nil
              raise ArgumentError, "value must not be empty"
            end
          end
        end  # end of DV_Boolean

        class DV_State < Data_Value
          attr_accessor :value
          attr_writer :terminal
          def initialize(value, terminal)
            if value == nil or terminal == nil
              raise ArgumentError, "argument mandatory"
            end
            @value = value
            @terminal = terminal
          end
          def is_terminal?
            @terminal == true
          end
        end # end of DV_State

        class DV_Identifier
          attr_accessor :issuer, :assigner, :id, :type
          def initialize(assigner, id, issuer, type)
            if assigner == nil or id == nil or issuer == nil or type == nil
              raise ArgumentError, "invalid argument"
            end
            @issuer = issuer
            @assigner = assigner
            @id = id
            @type = type
          end
        end #end of DV_Identifier
      end # end of Basic
    end # end of Data_types
  end # end of RM
end # end of OpenEHR
