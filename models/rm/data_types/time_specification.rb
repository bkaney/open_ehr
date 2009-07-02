# This module is related to the ticket #47

module OpenEHR
  module RM
    module Data_Types
      module Time_Specification
        class DV_Time_Specification < OpenEHR::RM::Data_Types::Basic::Data_Value
          attr_reader :value

          def initialize(value)
            self.value=(value)
          end

          def value=(value)
            raise ArgumentError, 'value must be not nil' if value.nil?
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
            super(value)
          end
          def value=(value)
            raise ArgumentError, "value is not valied" unless value.formalism.is_equal?('HL7:GTS')
            @value = value
          end
          private
          def value_valid(value)
          end
        end

        class DV_Periodic_Time_Specification < DV_Time_Specification
          attr_reader :value, :calender_alignment, :event_alingment, :period
          def initialize(value)
            value_valid(value)
            super(value)
          end
          def value=(value)
            unless value.formalism.is_equal('HL7:PIVL') or value.formalism.is_equal('HL7:EIVL')
              raise ArgumentError, "value is not valid"
            end
            /^\[(\d+)\;?(\d+)?\]\/\((\d+\w+)\)(@(\w+?))?(IST)?$/ =~ value
            interval1, interval2, difference, allignment = $1, $2, $3, $5
# not implemented because of unknown HL7 specification

          end

          def calender_alignment

          end

          def event_alignment

          end

          def institution_specified?

          end
          def period
          end
        end
      end
    end # of Data_Type
  end # of RM
end # of OpenEHR
