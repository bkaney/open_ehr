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
        end # of Primitive
      end # of CostraintModel
    end # of Archetype
  end # of AM
end # of OpenEHR
