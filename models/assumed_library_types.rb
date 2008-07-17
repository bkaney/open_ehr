require 'date'
require 'time'

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

      def self.valid_year?(year)
        year >= 0
      end

      def self.valid_day?(y, m, d)
        Date.valid_date?(y,m,d) and valid_year? y
      end

      def self.valid_hour?(h,m,s)
        valid_minute?(m) and valid_second?(s) and ((h >= 0 and h < HOURS_IN_DAY) or (h == HOURS_IN_DAY and m == 0 and s == 0))
      end
      def self.valid_minute?(mi)
        mi >= 0 and mi < MINUTES_IN_HOUR
      end
      def self.valid_second?(s)
        s >= 0 and s < SECONDS_IN_MINUTE
      end
      def self.valid_month?(mo)
        mo >= 1 and mo <= MONTH_IN_YEAR
      end
    end # end of TIME_DEFINITIONS

    class ISO8601_DATE < TIME_DEFINITIONS
      attr_reader :year, :month, :day
      def initialize(year = nil, month = nil, day = nil)
        @year = @month = @day = nil
        if !year.nil?
          self.year = year
        end
        if !month.nil?
          self.month = month
        end
        if !day.nil?
          self.day = day
        end
      end
      def year=(year)
        raise ArgumentError, "Year is not valid" if !ISO8601_DATE.valid_year?(year)
        @year = year
      end
      def month=(month)
        raise ArgumentError, "Month is not valid" if !ISO8601_DATE.valid_month?(month)
        @month = month
      end
      def day=(day)
        raise ArgumentError, "Day is not valid" if !ISO8601_DATE.valid_day?(@year, @month, day)
        @day = day
      end
      def as_string
        if (!@year.nil? and !@month.nil? and !@day.nil?)
          Date.new(@year, @month, @day).to_s
        elsif (!@year.nil? and !@month.nil? and @day.nil?)
          Date.new(@year, @month).to_s[0,7]
        elsif (!@year.nil? and @month.nil? and @day.nil?)
          Date.new(@year).to_s[0,4]
        end          
      end
      def month_unknown?
        @month.nil?
      end
      def day_unknown?
        @day.nil?
      end
      def is_extended?
        true
      end
      def is_partial?
        month_unknown? or day_unknown?
      end
      def self.valid_iso8601_date?(string)
        begin
          Date.parse(string)
        rescue
          return false
        end
        true
      end

    end # end of ISO8601_DATE

    class ISO8601_TIME < TIME_DEFINITIONS
      attr_reader :hh, :mm, :ss, :msec, :tz
      def initialize(hh = nil, mm = nil, ss = nil, msec = nil, tz = nil)
        
      end
      def as_string
        s = @hh
        if !@mm.nil?
          s += ":" + @mm
          if !@ss.nil?
            s += ":" + @ss
            if !@msec.nil?
              s += "," + @msec
              if !@tz.nil?
                s += @tz
              end
            end
          end
        end
        s
      end
      def self.valid_iso8601_time?(s)
        if /(\d{2}):?(\d{2})?(:?)(\d{2})?((\.|,)(\d+))?(Z|([+-](\d{2}):?(\d{2})))?/ =~ s
# ISO 8601 regular expression by H. Yuki
#  http://digit.que.ne.jp/work/wiki.cgi?Perl%E3%83%A1%E3%83%A2%2FW3C%E5%BD%A2%E5%BC%8F%E3%81%AE%E6%97%A5%E6%99%82%E3%81%AE%E8%A7%A3%E6%9E%90
# (\d{4})(?:-(\d{2})(?:-(\d{2})(?:T(\d{2}):(\d{2})(?::(\d{2})(?:\.(\d))?)?(Z|([+-]\d{2}):(\d{2}))?)?)?)?
          hh = $1; mm = $2; ss = $4; msec = $7; tz = $8
          if hh.to_i == HOURS_IN_DAY and (mm.nil? or mm.to_i == "00") and (ss.nil? or ss.to_i == "00")
            return true
          end
          if hh.nil? or (hh.to_i < 0 or hh.to_i >= HOURS_IN_DAY)
            return false
          end
          if !mm.nil? 
            if !self.valid_minute?(mm.to_i)
              return false
            end
          end
          if !ss.nil? 
            if !self.valid_second?(ss.to_i)
              return false
            end
          end
          if !tz.nil? and tz != "Z"
            if /[+-](\d{2}):?(\d{2})/ =~ tz
              h = $1; m = $2
              if h.to_i < 0 or h.to_i >= HOURS_IN_DAY
                return false
              end
              if m.to_i < 0 or m.to_i >= MINUTES_IN_HOUR
                return false
              end
            else
              return false
            end
          end
          return true
        else
          return false
        end
      end
    end # end of ISO8601_TIME

    class ISO8601_TIMEZONE
      attr_accessor :sign, :hour, :minute
      def is_gmt?
        @sign == "+1" and @hour == 0 and @minute == 0
      end
      def as_string
        if @sign == "+1"
          s = "+"
        elsif @sign == "-1"
          s = "-"
        end
        sprintf("Z%s%02d%02d", s, @hour, @minute)
      end
    end # end of ISO8601_TIMEZONE
  end # end of Assumed_Types
end # end of OpenEHR
