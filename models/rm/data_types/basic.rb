# This module is implemented from this UML:
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_0_76d0249_1109067591791_562382_3151Report.html
# Ticket refs #52
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
          attr_reader :value

          def initialize(value, is_terminal)
            self.value=value
            self.is_terminal=is_terminal
          end
          def value=(v)
            raise ArgumentError, "value should not be nil" if v.nil?
            @value = v
          end
          def is_terminal?
            @is_terminal
          end
          def is_terminal=(s)
            raise ArgumentError, "terminal should not be nil" if s.nil?
            @is_terminal = s
          end
          private
          def value_validity?
            @value.instance_of? OpenEHR::Data_Types::Text::DV_Coded_Text
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
