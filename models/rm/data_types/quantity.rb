module OpenEHR
  module RM
    module Data_Types
      module Quantity
        module DV_Ordered < OpenEHR::RM::Data_Types::Basic::Data_Value
          include Comparable
          attr_accessor :other_refference_ranges, :normal_range
          attr_accessor :normal_status
          def initialize(normal_range, other_reference_ranges,
                         normal_status = nil)
            other_reference_ranges_validity(other_reference_ranges)
            @normal_range = normal_range
            @other_reference_ranges = other_reference_ranges
            @normal_status = normal_status
          end          
          def is_normal?
            normal_range != nil or normal_status != nil
          end
          def is_simple?
            normal_status == nil and other_refference_ranges == nil
          end
          private
          def other_reference_ranges_validity(other_reference_ranges)
            if other_reference_ranges != null or other_reference_ranges.is_empty?
              raise ArgumentError, "Other reference ranges validity error"
            end
          end
        end
        module DV_Quantified
          include DV_Ordered
          def magnitude
          end
          def valid_magnitude_status(s)
          end
        end
      end # of Quantity
    end # of Data_Types
  end # of RM
end # of OpenEHR
