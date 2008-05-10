module OpenEHR
  module RM
    module Data_Types
      module Time_Specification
        class DV_Time_Specification < OpenEHR::RM::Data_Types::Basic::Data_Value
          def initialize(value)
            @value = value
          end
          def calender_alignment
            raise NotImlementedError, "calender_alignment must be implemented"
          end
          def event_alignment
            raise NotImlementedError, "event_alignment must be implemented"
          end
          def institution_specified
            raise NotImlementedError, "institution_specified must be implemented"
          end
        end
        
        class DV_General_Time_Specification < DV_Time_Specification
          attr_reader :value
          def initialize(value)
            value_valid(value)
            super(value)
          end
          def value=(value)
            value_valid(value)
            @value = value
          end
          private
          def value_valid(value)
            raise ArgumentError, "value is not valied" if !value.formalism.is_equal?('HL7:GTS')
          end
        end

        class DV_Periodic_Time_Specification < DV_Time_Specification
          attr_reader :value
          def initialize(value)
            value_valid(value)
            super(value)
          end
          def calender_alignment
          end
          def event_alignment
          end
          def institution_specified?
          end
          def period
          end
          private
          def value_valid(value)
            if !value.formalism.is_equal('HL7:PIVL') && value.formalism.is_equal('HL7:EIVL')
              raise ArgumentError, "value is not valid"
            end
          end
        end
      end
    end # of Data_Type
  end # of RM
end # of OpenEHR
