# This module is implementation of the UML:
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_0_76d0249_1109696321450_28117_5362Report.html
# Ticket refs #49
module OpenEHR
  module RM
    module Data_Types
      module Quantity
        module Date_Time
          class DV_Temporal < OpenEHR::RM::Data_Types::Quantity::DV_Absolute_Quantity
            attr_reader :value
            def initialize(value)
              self.value = value
            end
            def value=(value)
              if value.empty? or value.nil?
                raise ArgumentError, 'invalid value'
              end
              @value = value
            end
            def diff(value)
              raise NotImplementedError, 'diff must be implemented'
            end
          end

          class DV_Date < DV_Temporal
            def initialize
            end
          end
        end # of Date_Time
      end # of Quantity
    end # of Data_Types
  end # of RM
end # of OpenEHR
