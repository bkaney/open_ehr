module OpenEHR
  module RM
    module Support
      module Assumed_Types
        class Interval
          attr_accessor :lower, :upper
#          attr_accessor :lower_included, :lower_unbounded
#          attr_accessor :upper_included, :upper_unbounded
          def initialize(lower, upper,
                         lower_included = nil, upper_included = nil)
            if ((lower !=nil) && (upper !=nil)) && lower>upper
              raise ArgumentError, "upper < lower"
            end
            @lower = lower
            @upper = upper
          end
        end
      end
    end
  end
end
