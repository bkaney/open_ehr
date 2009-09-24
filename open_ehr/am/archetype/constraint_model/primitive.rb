module OpenEhr
  module AM
    module Archetype
      module Constraint_Model

        module Primitive

          class C_PRIMITIVE

            def initialize
              raise "abstract class"
            end

            def self.create(args = {})
              instance = new(args)

              if block_given?
                yield instance
              end
              return instance
            end


            def assumed_value
              raise NotImplementedError, "assumed_value should be implemented"
            end

            def default_value
              raise NotImplementedError, "assumed_value should be implemented"
            end

            def has_assumed_value?
              assumed_value != nil
            end

            def valid_value?
              raise NotImplementedError, "valid_value? should be implemented"
            end
          end

          class C_BOOLEAN < C_PRIMITIVE
            attr_reader :true_valid, :false_valid, :assumed_value

            def initialize(args = { })
              @true_valid = args[:true_valid] ? args[:true_valid] : false
              @false_valid = args[:false_valid] ? args[:false_valid] : false
              @assumed_value = args[:assumed_value] ? args[:assumed_value] : false
              binary_consistency(@true_valid, @false_valid)
            end

            def true_valid=(true_valid)
              binary_consistency(true_valid, @false_valid)
              @true_valid = true_valid
            end

            def false_valid=(false_valid)
              binary_consistency(@true_valid,false_valid)
              @false_valid = false_valid 
            end

            def valid_value?
              
            end

            def default_value(a_value = nil)
              if a_value == nil
                @true_valid
              else
                (a_value && @true_valid) || (!a_value && @false_valid) 
              end
            end

            private 

            def binary_consistency(true_valid, false_valid)
              if !true_valid && !false_valid
                raise ArgumentError, "Either true_valid or false_valid must be true"
              end
            end
          end # of C_Boolean

          class C_STRING < C_PRIMITIVE
            attr_accessor :list, :assumed_value, :list_open, :pattern

            def initialize(args = { })
              @list, @assumed_value, @list_open, @pattern = args[:list], args[:assumed_value], args[:list_open], args[:pattern]
            end
          end

          class C_INTEGER < C_PRIMITIVE
            attr_accessor :list, :range, :assumed_value

            def initialize(args = { })
              @list, @range, @assumed_value = args[:list], args[:range], args[:assumed_value]
            end

            def self.create(args = {})
              c_primitive = new(args)

              if block_given?
                yield c_primitive
              end
              return c_primitive
            end
          end

          class C_REAL < C_PRIMITIVE
            attr_accessor :list, :range, :assumed_value

            def initialize(args = { })
              @list, @range, @assumed_value = args[:list], args[:range], args[:assumed_value]
            end
          end

          class C_TIME < C_PRIMITIVE
            attr_accessor :assumed_value, :milli_second_validity, :minute_validity, :range, :second_validity, :timezone_validity
            def initialize(args = { })
              @assumed_value, @milli_second_validity, @minute_validity, @month_validity, @range, @second_validity, @timezone_validity = args[:assumed_value], args[:milli_second_validity], args[:minute_validity], args[:range], args[:second_validity], args[:timezone_validity]
            end
          end

          class C_DATE < C_PRIMITIVE
            attr_accessor :assumed_value, :day_validity, :hour_validity, :month_validity, :range, :timezone_validity
            def initialize(args = { })
              @assumed_value, @day_validity, @hour_validity,  @month_validity, @range,  @timezone_validity = args[:assumed_value], args[:day_validity], args[:hour_validity], args[:month_validity], args[:range], args[:timezone_validity]
            end
          end

          class C_DATE_TIME < C_PRIMITIVE
            attr_accessor :assumed_value, :day_validity, :hour_validity, :milli_second_validity, :minute_validity, :month_validity, :range, :second_validity, :timezone_validity
            def initialize(args = { })
              @assumed_value, @day_validity, @hour_validity, @milli_second_validity, @minute_validity, @month_validity, @range, @second_validity, @timezone_validity = args[:assumed_value], args[:day_validity], args[:hour_validity], args[:milli_second_validity], args[:minute_validity], args[:month_validity], args[:range], args[:second_validity], args[:timezone_validity]
            end
          end

          class C_DURATION < C_PRIMITIVE
            attr_accessor :years_allowed, :months_allowed, :weeks_allowed, :days_allowed, :hours_allowed, :minutes_allowed, :seconds_allowed, :fractional_seconds_allowed, :range, :assumed_value

            def initialize(args = { })
              @years_allowed, @months_allowed, @weeks_allowed, @days_allowed, @hours_allowed, @minutes_allowed, @seconds_allowed, @fractional_seconds_allowed, @range, @assumed_value = args[:years_allowed], args[:months_allowed], args[:weeks_allowed], args[:days_allowed], args[:hours_allowed], args[:minutes_allowed], args[:seconds_allowed], args[:fractional_seconds_allowed], args[:range], args[:assumed_value]
            end
          end



        end # of Primitive
      end # of Constraint_Model
    end # of Archetype
  end # of AM
end # of OpenEHR
