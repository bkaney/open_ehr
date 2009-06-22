# This modules are implemented from the UML shown bellow
# http://www.openehr.org/uml/release-1.0.1/Browsable/_9_0_76d0249_1109599337877_94556_1510Report.html
# Ticket refs #50
require 'assumed_library_types'
module OpenEHR
  module RM
    module Data_Types
      module Quantity

        autoload :Date_Time, "rm/data_types/quantity/date_time.rb"

        class DV_Ordered < OpenEHR::RM::Data_Types::Basic::Data_Value
          include Comparable
          attr_accessor :normal_range, :other_refference_ranges, :normal_status

          def initialize(normal_range=nil, normal_status = nil,
                         other_reference_ranges=nil)
            self.normal_range = normal_range
            self.normal_status = normal_status
            self.other_reference_ranges = other_reference_ranges
          end          

          def is_normal?
            if @normal_range.nil? and @normal_status.nil?
              return false
            elsif !@normal_range.nil?
              return @normal_range.has(@value)
            elsif !@normal_status.nil?
              return @normal_status.code_string == 'N'
            end
          end

          def is_simple?
            normal_status.nil? and other_refference_ranges.nil?
          end

          def <=>(other)
            raise NotImplementedError, 'This method should be implemented'
          end

          def other_reference_ranges=(other_reference_ranges)
            unless other_reference_ranges.nil? or !other_reference_ranges.is_empty?
              raise ArgumentError, "Other reference ranges validity error"
            end
            @other_reference_ranges = other_reference_ranges
          end

          def is_strictly_comparable_to?(other)
            raise NotImplementedError, 'this method should be implemented'
          end
        end

        class DV_Interval < OpenEHR::Assumed_Library_Types::Interval

        end

        class DV_Quantified < DV_Ordered

          def initialize(normal_range=nil, normal_status = nil,
                         other_reference_ranges=nil)
            super(normal_range, normal_status, other_reference_ranges)
          end

          def magnitude
            
          end

          def <=>(others)
            @value <=> others.value
          end

          def valid_magnitude_status(s)

          end
        end

        class DV_Ordinal < DV_Ordered
          attr_reader :value, :symbol, :limits

          def initialize(value, symbol, limits=nil, normal_range=nil,
                         normal_status = nil, other_reference_ranges=nil)
            self.value = value
            self.symbol = symbol
            self.limits = limits
            super(normal_range, normal_status, other_reference_ranges)
          end

          def value=(value)
            raise ArgumentError, 'value should not be nil' if value.nil?
            @value = value
          end

          def symbol=(symbol)
            raise ArgumentError,'symbol should not be nil' if symbol.nil?
            @symbol = symbol
          end

          def is_strictly_comparable_to?(others)
            unless others.instance_of? OpenEHR::RM::Data_Types::Quantity::DV_Ordinal
              return false
            end
            unless others.symbol.defining_code.terminology_id.value ==
                @symbol.defining_code.terminology_id.value
              return false
            end
            return true
          end

          def <=>(other)
            @value <=> other.value
          end

          def limits=(limits)
            unless limits.nil? or limits.meaning.value == 'limits'
              raise ArgumentError, 'invalid limits'
            else
              @limits = limits
            end
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

        class DV_Quantity < DV_Amount

        end

        class Reference_Range
          attr_reader :meaning

          def initialize(meaning)
            self.meaning = meaning
          end

          def meaning=(meaning)
            if meaning.nil?
              raise ArgumentError, 'meaning should not be nil'
            end
            @meaning = meaning
          end
        end

        module Proportion_Kind
          PK_RATIO = 0
          PK_UNITARY = 1
          PK_PERCENT = 2
          PK_FRACTION = 3
          PK_INTEGER_FRACTION = 4

          def Proportion_Kind.valid_proportion_kind?(kind)
            return true if kind >= 0 && kind <= 4
            return false
          end
        end # end of Proportion_Kind
      end # of Quantity
    end # of Data_Types
  end # of RM
end # of OpenEHR
