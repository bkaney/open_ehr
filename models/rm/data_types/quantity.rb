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
          attr_reader :magnitude, :magnitude_status, :accuracy

          def initialize(magnitude, magnitude_status=nil,
                         normal_range=nil, normal_status = nil,
                         other_reference_ranges=nil)
            super(normal_range, normal_status, other_reference_ranges)
            self.magnitude = magnitude
            self.magnitude_status = magnitude_status
          end

          def <=>(others)
            @value <=> others.value
          end

          def magnitude=(magnitude)
            raise ArgumentError, 'magnitude should not be nil' if magnitude.nil?
            @magnitude = magnitude
          end

          def magnitude_status=(magnitude_status)
            if magnitude_status.nil?
              @magnitude_status = '='
            elsif DV_Quantified.valid_magnitude_status?(magnitude_status)
              @magnitude_status = magnitude_status
            else
              raise ArgumentError, 'magnitude_status invalid'
            end
          end

          def accuracy=(accuracy)
            raise NotImplementedError, 'subclasses need to implemented'
          end

          def accuracy_unknown?
            return accuracy.nil?
          end

          def self.valid_magnitude_status?(s)
            if s == '=' || s == '>' || s == '<' || s == '<=' ||
                s == '>=' || s == '~'
              return true
            else
              return false
            end
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
          attr_reader :accuracy_is_percent
          def initialize(magnitude, magnitude_status=nil, accuracy=nil,
                         accuracy_percent=nil, normal_range=nil,
                         normal_status = nil, other_reference_ranges=nil)
            super(magnitude, magnitude_status, normal_range,
                  normal_status, other_reference_ranges)
            set_accuracy(accuracy, accuracy_percent) unless accuracy.nil?
          end
          def +(other)
            raise NotImplementError, '+ operator must be overloaded'
          end

          def -(other)
            raise NotImplementError, '- operator must be overloaded'
          end

          def set_accuracy(accuracy, accuracy_percent)
            if accuracy_percent
              raise ArgumentError, 'accuracy invalid' if accuracy < 0.0 || accuracy > 100.0
            else
              raise ArgumentError, 'accuracy invaild' if accuracy < 0.0 || accuracy > 1.0
            end
            @accuracy, @accuracy_percent = accuracy, accuracy_percent
          end

          def accuracy_is_percent?
            return @accuracy_percent
          end
        end

        class DV_Quantity < DV_Amount

        end

        class Reference_Range
          attr_reader :meaning, :range

          def initialize(meaning, range)
            self.meaning = meaning
            self.range = range
          end

          def meaning=(meaning)
            if meaning.nil?
              raise ArgumentError, 'meaning should not be nil'
            end
            @meaning = meaning
          end

          def range=(range)
            if range.nil?
              raise ArgumentError, 'range should not be nil'
            end
            @range = range
          end

          def is_in_range?(val)
            return @range.has?(val)
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
