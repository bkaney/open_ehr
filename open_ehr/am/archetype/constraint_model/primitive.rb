

module OpenEHR
  module AM
    module Archetype
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
      end # of Primitive
    end # of Archetype
  end # of AM
end # of OpenEHR
