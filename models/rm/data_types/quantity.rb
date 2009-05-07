# This modules are implemented from the UML shown bellow
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_0_76d0249_1109599337877_94556_1510Report.html
# Ticket refs #50
module OpenEHR
  module RM
    module Data_Types
      module Quantity
        class DV_Ordered < OpenEHR::RM::Data_Types::Basic::Data_Value
          include Comparable
          attr_reader :other_refference_ranges, :normal_range, :normal_status

          def initialize(normal_range=nil, other_reference_ranges=nil,
                         normal_status = nil)
            other_reference_ranges_validity(other_reference_ranges)
            @normal_range = normal_range
            @other_reference_ranges = other_reference_ranges
            @normal_status = normal_status
          end          

          def is_normal?
            !normal_range.nil? or !normal_status.nil
          end

          def is_simple?
            normal_status.nil? and other_refference_ranges.nil?
          end

          def <=>(other)
            raise NotImplementError, 'This method should be implemented'
          end

          def normal_range=(normal_range)
          end

          def other_reference_ranges=(other_reference_ranges)
          end

          private
          def other_reference_ranges_validity(other_reference_ranges)
            if !other_reference_ranges.nil? or other_reference_ranges.is_empty?
              raise ArgumentError, "Other reference ranges validity error"
            end
          end
        end

        class DV_Quantified < DV_Ordered
          def magnitude
          end
          def valid_magnitude_status(s)
          end
        end

        class DV_Ordinal < DV_Ordered
          attr_reader :symbol, :value
          def is_strictly_comparable_to?
          end
          def limits
          end
        end

        class DV_Absolute_Quantity < DV_Quantified
          attr_reader :accuracy

          def add(a_diff)
            raise NotImplementError, 'add must be implemented'
          end

          def diff(other)
            raise NotImplementError, 'diff must be implemented'
          end

          def subtract(a_diff)
            raise NotImplementError, 'subtract must be implemented'
          end
        end

        class DV_Amount < DV_Quantified
          attr_reader :accuracy, :accuracy_is_percent
          def infix(dv_amount, op)
            raise NotImplementError, 'infix must be implemented'
          end
          def accuracy=(accuracy)
            raise ArgumentError, 'accuracy invalid'
          end
        end

        autoload :Date_Time, "rm/data_types/quantity/date_time.rb"
        
      end # of Quantity
    end # of Data_Types
  end # of RM
end # of OpenEHR
