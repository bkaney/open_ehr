# This module is related to the ticket #36
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

      def self.valid_hour?(h,m = nil, s = nil)
        if !m.nil? and !valid_minute?(m)
          return false
        end
        if !s.nil? and (!m.nil? and !valid_second?(s))
          return false
        end
        (h >= 0 and h < HOURS_IN_DAY) or (h == HOURS_IN_DAY and m == 0 and s == 0)
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

    module ISO8601_DATE_MODULE
      attr_reader :year, :month, :day
      def year=(year)
        raise ArgumentError, "Year is not valid" unless ISO8601_DATE.valid_year?(year)
        @year = year
      end
      def month=(month)
        raise ArgumentError, "Month is not valid" unless month.nil? or ISO8601_DATE.valid_month?(month)
        @month = month
      end
      def day=(day)
        raise ArgumentError, "Day is not valid" unless day.nil? or ISO8601_DATE.valid_day?(@year, @month, day)
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
    end

    class ISO8601_DATE < TIME_DEFINITIONS
      include ISO8601_DATE_MODULE
      def initialize(string)
        /(\d{4})(?:-(\d{2})(?:-(\d{2})?)?)?/ =~ string
        if $1.nil?
          raise ArgumentError, 'data invalid'
        else
          self.year = $1.to_i
        end
        if $2.nil?
          self.month = nil
        else
          self.month = $2.to_i
        end
        if $3.nil?
          self.day = nil
        else
          self.day = $3.to_i
        end
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

    module ISO8601_TIME_MODULE
      attr_reader :hour, :minute, :second, :fractional_second, :timezone

      def hour=(hour)
        raise ArgumentError, "hour is not valid" if !ISO8601_TIME.valid_hour?(hour, @minute, @second)
        @hour = hour
      end

      def minute_unknown?
        @minute.nil?
      end

      def minute=(minute)
        raise ArgumentError, "minute is not valid" if !minute.nil? and !ISO8601_TIME.valid_minute?(minute)
        @minute = minute
      end

      def second_unknown?
        @second.nil?
      end

      def second=(second)
        raise ArgumentError, "minute not defined" if @minute.nil? and !second.nil?
        raise ArgumentError, "second is not valid" if !second.nil? and !ISO8601_TIME.valid_second?(second)
        @second = second
      end

      def fractional_second=(fractional_second)
        raise ArgumentError, "minute not defined" if minute_unknown? and !fractional_second.nil?
        raise ArgumentError, "second not defined" if second_unknown? and !fractional_second.nil?
        raise ArgumentError, "fractional second should be lower than 1.0" if !fractional_second.nil? and fractional_second >= 1.0
        @fractional_second = fractional_second
      end

      def has_fractional_second?
        if @fractional_second.nil?
          return false
        else
          return true
        end
      end

      def timezone=(timezone)
        unless timezone.nil? or timezone == 'Z'
          if /[+-](\d{2}):?(\d{2})/ =~ timezone
            @timezone = timezone
          else
            raise ArgumentError, "timezone invalid"
          end
        else
          @timezone = nil
        end
      end

      def is_decimal_sign_comma?
        true
      end

      def is_extended?
        true
      end

      def is_partial?
        second_unknown? or minute_unknown?
      end
      def as_string
        s = sprintf("%02d", @hour)
        if !@minute.nil?
          s += ":" + sprintf("%02d",@minute)
          if !@second.nil?
            s += ":" + sprintf("%02d", @second)
            if !@fractional_second.nil?
              s += "," + @fractional_second.to_s[2..-1]
              if !@timezone.nil?
                s += @timezone
              end
            end
          end
        end
        s
      end
    end

    class ISO8601_TIME < TIME_DEFINITIONS
      include ISO8601_TIME_MODULE
      def initialize(string)
        /(\d{2}):?(\d{2})?(:?)(\d{2})?((\.|,)(\d+))?(Z|([+-](\d{2}):?(\d{2})))?/ =~ string
        if $2.nil?
          self.minute = nil
        else
          self.minute = $2.to_i
        end
        if $4.nil?
          self.second = nil
        else
          self.second = $4.to_i
        end
        if $1.nil?
          raise ArgumentError, 'data invalid'
        else
          self.hour = $1.to_i
        end
        if $7.nil?
          self.fractional_second = nil
        else
          self.fractional_second = ("0." + $7).to_f
        end
        if $8.nil?
          self.timezone = nil
        else
          self.timezone = $8
        end
      end
      def self.valid_iso8601_time?(s)
        if /(\d{2}):?(\d{2})?(:?)(\d{2})?((\.|,)(\d+))?(Z|([+-](\d{2}):?(\d{2})))?/ =~ s
# ISO 8601 regular expression by H. Yuki
#  http://digit.que.ne.jp/work/wiki.cgi?Perl%E3%83%A1%E3%83%A2%2FW3C%E5%BD%A2%E5%BC%8F%E3%81%AE%E6%97%A5%E6%99%82%E3%81%AE%E8%A7%A3%E6%9E%90
# (\d{4})(?:-(\d{2})(?:-(\d{2})(?:T(\d{2}):(\d{2})(?::(\d{2})(?:\.(\d))?)?(Z|([+-]\d{2}):(\d{2}))?)?)?)?
          hh = $1; mm = $2; ss = $4; msec = $7; tz = $8
          if hh.to_i == HOURS_IN_DAY and (mm.nil? or mm.to_i == 0) and (ss.nil? or ss.to_i == 0) and (msec.nil? or msec.to_i==0)
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

    class ISO8601_DATE_TIME < ISO8601_DATE
      include ISO8601_DATE_MODULE, ISO8601_TIME_MODULE
      def initialize(string)
        /(\d{4})(?:-(\d{2})(?:-(\d{2})(?:T(\d{2}):(\d{2})(?::(\d{2})(?:\.(\d+))?)?(Z|([+-]\d{2}):?(\d{2}))?)?)?)?/ =~ string
        if $1.empty?
          raise ArgumentError, 'format invalid'
        else
          self.year = $1.to_i
        end
        if $2.nil?
          self.month = nil
        else
          self.month = $2.to_i
        end
        if $3.nil?
          self.day = nil
        else
          self.day = $3.to_i
        end
        if $5.nil?
          self.minute = nil
        else
          self.minute = $5.to_i
        end
        if $6.nil?
          self.second = nil
        else
          self.second = $6.to_i
        end
        if $4.nil?
          self.hour = nil
        else
          self.hour = $4.to_i
        end
        if $7.nil? or $7.empty?
          self.fractional_second = nil
        else
          self.fractional_second = ("0."+$7).to_f
        end
        if $8.nil?
          self.timezone = nil
        else
          self.timezone = $9+$10
        end
      end
    end

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

    class ISO8601_DURATION
      
      def initialize
        
      end

      def as_string

      end
    end # end of ISO8601_DURATION
  end # end of Assumed_Types
end # end of OpenEHR
