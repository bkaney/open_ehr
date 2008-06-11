module OpenEHR
  module Assumed_Library_Types
    class Any < Object
      
    end # of Any
    class Interval < Any
      attr_reader :lower, :lower_included, :lower_unbounded
      attr_reader :upper, :upper_included, :upper_unbounded
      def initialize(lower, upper, 
                     lower_included = nil, upper_included = nil)
        check_lower_upper(lower, upper)
        set_lower_included(lower_included)
        set_upper_included(upper_included)
      end

      def set_lower(lower)
        check_lower_upper(lower, @upper)
      end

      def set_upper(upper)
        check_lower_upper(@lower, upper)
      end

      def set_lower_included(lower_included)
        if (lower == nil) && (lower_included != nil)
          raise ArgumentError, "lower is not set"
        end
        @lower_included = lower_included
      end

      def set_upper_included(upper_included)
        @upper_included = upper_included
        if (upper == nil) && (upper_included != nil)
          raise ArgumentError, "upper is not set"
        end
      end

      def has?(value)
        if ((@lower < value) && (value < @upper) ||
            (@lower_included == true) && (@lower == value) ||
            (@upper_included == true) && (@upper == value))
          true
        else
          false
        end
      end

      private

      def check_lower_upper(lower, upper)
        if (lower == nil) && (upper == nil)
          raise ArgumentError, "Either lower or upper must be assigned"
        end
        if (lower == nil) && (upper != nil)
          @lower_unbounded = true          
        elsif (lower != nil) && (upper == nil)
          @upper_unbounded = true
        elsif lower > upper
          raise ArgumentError, "Upper must be larger than lower."
        end
        @lower = lower
        @upper = upper
      end      
    end # end of Interval

    class TIME_DEFINITIONS < Any
      DAYS_IN_LEAP_YEAR = 366
      DAYS_IN_WEEK = 7
      DAYS_IN_YEAR = 365
      HOURS_IN_DAY = 24
      MAX_DAYS_IN_MONTH = 31
      MAX_DAYS_IN_YEAR = 366
      MINUTES_IN_HOUR = 60
      MONTH_IN_YEAR = 12
      NOMINAL_DAYS_IN_MONTH = 30.42
      NOMINAL_DAYS_IN_YEAR = 365.24
      SECONDS_IN_MINUTE = 60
    end # end of TIME_DEFINITIONS

    class ISO_8601_DATE < TIME_DEFINITIONS
      
    end # end of ISO_8601_DATE
  end # end of Assumed_Types
end # end of OpenEHR
