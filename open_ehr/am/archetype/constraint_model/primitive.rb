# Ticket #71
module OpenEHR
  module AM
    module Archetype
      module ConstraintModel
        module Primitive
          class CPrimitive
            attr_reader :default_value
            attr_accessor :assumed_value

            def initialize(args = { })
              self.default_value = args[:default_value]
              self.assumed_value = args[:assumed_value]
            end

            def default_value=(default_value)
              if default_value.nil?
                raise ArgumentError, 'default_value is mandatory'
              end
              @default_value = default_value
            end

            def has_assumed_value?
              return !assumed_value.nil?
            end
          end

          class CBoolean < CPrimitive
            attr_reader :true_valid, :false_valid

            def initialize(args = { })
              binary_consistency(args[:true_valid], args[:false_valid])
              @true_valid = args[:true_valid]
              @false_valid = args[:false_valid]
              super(args)
            end

            def default_value=(default_value)
              super
              default_value_consistency(default_value)
            end

            def true_valid=(true_valid)
              binary_consistency(true_valid, @false_valid)
              @true_valid = true_valid
            end

            def false_valid=(false_valid)
              binary_consistency(@true_valid, false_valid)
              @false_valid = false_valid
            end

            def true_valid?
              return @true_valid
            end

            def false_valid?
              return @false_valid
            end

            private
            def binary_consistency(true_valid, false_valid)
              if (true_valid == false) && (false_valid == false)
                raise ArgumentError, 'true_valid or false_valid should be true'
              end
            end

            def default_value_consistency(default_value)
              if (!@true_valid && default_value) || (!@false_valid && !default_value)
                raise ArgumentError, 'default value inconsistency'
              end
            end
          end

          class CString < CPrimitive
            attr_reader :pattern, :list

            def initialize(args = { })
              super
              consistency(args[:pattern], args[:list])
              @pattern = args[:pattern]
              @list = args[:list]
            end

            def pattern=(pattern)
              consistency(pattern, @list)
              @pattern = pattern
            end

            def list=(list)
              consistency(@pattern, list)
              @list = list
            end

            private
            def consistency(pattern, list)
              if pattern.nil? == list.nil?
                raise ArgumentError, 'consistency invaild'
              end
            end
          end

          class CInteger < CPrimitive
            attr_reader :list, :range

            def initialize(args = { })
              super
              consistency(args[:list], args[:range])
              @list = args[:list]
              @range = args[:range]
            end

            def list=(list)
              consistency(list, @range)
              @list = list
            end

            def range=(range)
              consistency(@list, range)
              @range = range
            end

            private
            def consistency(list, range)
              if list.nil? == range.nil?
                raise ArgumentError, 'consistency invalid'
              end
            end
          end

          class CReal < CInteger

          end

          class CDate < CPrimitive
            attr_accessor :range, :timezone_validity
            attr_reader :month_validity, :day_validity

            def initialize(args = { })
              super(args)
              self.range = args[:range]
              consistency_validity(args[:month_validity], args[:day_validity])
              @month_validity = args[:month_validity]
              @day_validity = args[:day_validity]
              self.timezone_validity = args[:timezone_validity]
            end

            def month_validity=(month_validity)
              consistency_validity(month_validity, @day_validity)
              @month_validity = month_validity
            end

            def day_validity=(day_validity)
              consistency_validity(@month_validity, day_validity)
              @day_validity = day_validity
            end

            def validity_is_range?
              return !@range.nil?
            end

            private
            def consistency_validity(month_validity, day_validity)
              if (month_validity == ValidityKind::OPTIONAL) &&
                  !((day_validity == ValidityKind::OPTIONAL) ||
                    (day_validity == ValidityKind::DISALLOWED))
                raise ArgumentError, 'month_validity inconsistent'
              end
              if (month_validity == ValidityKind::DISALLOWED) &&
                  !(day_validity == ValidityKind::DISALLOWED)
                raise ArgumentError, 'month validity disallowed'
              end
            end
          end

          class CTime < CPrimitive
            attr_accessor :range
            attr_reader :minute_validity, :second_validity,
                        :millisecond_validity

            def initialize(args = { })
              super
              self.range = args[:range]
              self.millisecond_validity = args[:millisecond_validity]
              self.second_validity = args[:second_validity]
              self.minute_validity = args[:minute_validity]
            end

            def minute_validity=(minute_validity)
              if (minute_validity == ValidityKind::OPTIONAL &&
                  @second_validity == ValidityKind::MANDATORY) ||
                  (minute_validity == ValidityKind::DISALLOWED &&
                   @second_validity != ValidityKind::DISALLOWED)
                raise ArgumentError, 'minute_validity is invalid'
              end
              @minute_validity = minute_validity
            end

            def second_validity=(second_validity)
              if (second_validity == ValidityKind::OPTIONAL &&
                  @millisecond_validity == ValidityKind::MANDATORY) ||
                  (second_validity == ValidityKind::DISALLOWED &&
                   @millisecond_validity != ValidityKind::DISALLOWED)
                raise ArgumentError, 'second_validity is invalid'
              end
              @second_validity = second_validity
            end

            def millisecond_validity=(millisecond_validity)
              @millisecond_validity = millisecond_validity
            end

            def validity_is_range?
              return !@range.nil?
            end
          end
        end # of Primitive
      end # of CostraintModel
    end # of Archetype
  end # of AM
end # of OpenEHR
