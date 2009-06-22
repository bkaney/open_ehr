require 'test/unit'
require 'assumed_library_types.rb'

class Assumed_Library_Test < Test::Unit::TestCase
  def setup
    assert_nothing_raised(Exception){@interval = OpenEHR::Assumed_Library_Types::Interval.new(1,2)}
    assert_nothing_raised(Exception){@time_definition = OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.new}
    assert_nothing_raised(Exception){@iso8601_date = OpenEHR::Assumed_Library_Types::ISO8601_DATE.new('2009-04-27')}
    assert_nothing_raised(Exception){@iso8601_time = OpenEHR::Assumed_Library_Types::ISO8601_TIME.new('15:55:37.32+0900')}
    assert_nothing_raised(Exception){@iso8601_date_time = OpenEHR::Assumed_Library_Types::ISO8601_DATE_TIME.new('2009-04-27T15:55:37.32+0900')}
    assert_nothing_raised(Exception){@iso8601_duration = OpenEHR::Assumed_Library_Types::ISO8601_DURATION.new('P1Y2M3W4DT5H6M7.8S')}
    assert_nothing_raised(Exception){@iso8601_timezone = OpenEHR::Assumed_Library_Types::ISO8601_TIMEZONE.new}
  end

  def test_initialize
    assert_instance_of OpenEHR::Assumed_Library_Types::Interval, @interval
    assert_instance_of OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS, @time_definition
    assert_instance_of OpenEHR::Assumed_Library_Types::ISO8601_DATE, @iso8601_date
    assert_instance_of OpenEHR::Assumed_Library_Types::ISO8601_TIME, @iso8601_time
    assert_instance_of OpenEHR::Assumed_Library_Types::ISO8601_DATE_TIME, @iso8601_date_time
    assert_instance_of OpenEHR::Assumed_Library_Types::ISO8601_DURATION, @iso8601_duration
    assert_instance_of OpenEHR::Assumed_Library_Types::ISO8601_TIMEZONE, @iso8601_timezone
  end

  def test_limits_comparable
    assert @interval.lower < @interval.upper
    assert_nothing_raised(Exception){@interval.lower=1.0}
    assert_nothing_raised(Exception){@interval.upper=2.0}
    assert @interval.lower < @interval.upper
  end

  def test_limits_consistent
    assert @interval.has?(1.5)
    assert !@interval.has?(3.0)
    assert !@interval.has?(0.5)
    assert_nothing_raised(Exception){@interval.lower_included=true}
    assert @interval.has?(1.0)
    assert_nothing_raised(Exception){@interval.lower_included=false}
    assert !@interval.has?(1.0)
    assert_nothing_raised(Exception){@interval.upper_included=true}
    assert @interval.has?(2.0)
    assert_nothing_raised(Exception){@interval.upper_included=false}
    assert !@interval.has?(2.0)
  end

  def test_lower_included_valid
    assert_nothing_raised(Exception){@interval.lower=nil}
    assert @interval.lower_unbounded?
    assert !@interval.lower_included?
    assert_nothing_raised(Exception){@interval.lower=1.0}
  end

  def test_upper_included_valid
    assert_nothing_raised(Exception){@interval.upper=nil}
    assert @interval.upper_unbounded?
    assert !@interval.upper_included?
  end

  def test_time_definitions
    assert_equal OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS::DAYS_IN_LEAP_YEAR, 366
    assert_equal OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS::DAYS_IN_WEEK, 7
    assert_equal OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS::DAYS_IN_YEAR, 365
    assert_equal OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS::HOURS_IN_DAY, 24
    assert_equal OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS::MAX_DAYS_IN_MONTH, 31
    assert_equal OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS::MAX_DAYS_IN_YEAR, 366
    assert_equal OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS::MINUTES_IN_HOUR, 60
    assert_equal OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS::MONTH_IN_YEAR, 12
    assert_equal OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS::NOMINAL_DAYS_IN_MONTH, 30.42
    assert_equal OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS::NOMINAL_DAYS_IN_YEAR, 365.24
    assert_equal OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS::SECONDS_IN_MINUTE, 60
  end

  def test_time_definition_validity
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_year?(2008)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_year?(-20)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_year?(0)
# today
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,6,19)
# test valid_day lower limit
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(0,0,0)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(0,1,1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(-1,1,1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(0,1,0)
# test valid_day upper and lowerlimit of each month
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(0,0,1)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,1,1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,1,0)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,0,1)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,1,31)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,1,32)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,2,1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,2,0)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,2,31)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,3,1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,3,0)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,3,31)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,3,32)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,4,1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,4,0)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,4,30)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,4,31)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,5,1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,5,0)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,5,31)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,5,32)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,6,1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,6,0)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,6,30)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,6,31)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,7,1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,7,0)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,7,31)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,7,32)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,8,1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,8,0)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,8,31)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,8,32)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,9,1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,9,0)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,9,30)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,9,31)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,10,1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,10,0)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,10,31)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,10,32)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,11,1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,11,0)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,11,30)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,11,31)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,12,1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,12,0)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,12,31)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,12,32)
# test valid_day leap year
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(1900,2,28)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(1900,2,29)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2000,2,29)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_day?(2008,2,29)
# test valid_hour lower limit
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_hour?(0,0,0)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_hour?(-1,0,0)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_hour?(0,-1,0)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_hour?(0,0,-1)
# test valid_hour upper limit
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_hour?(0,59,0)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_hour?(0,60,0)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_hour?(0,0,59)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_hour?(0,0,60)
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_hour?(24,0,0)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_hour?(24,0,1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_hour?(24,1,0)
# test valid_minute method lower limit
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_minute?(0)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_minute?(-1)
# test valid_minute method upper limit
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_minute?(59)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_minute?(60)
# test valid_second method lower limit
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_second?(0)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_second?(-1)
# test valid_second method upper limit
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_second?(59)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_second?(60)
# test valid_month method lower limit
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_month?(1)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_month?(0)
# test valid_month method upper limit
    assert OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_month?(12)
    assert !OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.valid_month?(13)
  end
  def test_iso8601_date
    assert_equal 2009, @iso8601_date.year
    assert_equal 4,@iso8601_date.month
    assert_equal 27,@iso8601_date.day
    assert_nothing_raised(Exception){@iso8601_date = OpenEHR::Assumed_Library_Types::ISO8601_DATE.new('2008')}
    assert @iso8601_date.day_unknown?
    assert @iso8601_date.month_unknown?
    assert @iso8601_date.is_partial?
    assert @iso8601_date.is_extended?
    assert_nothing_raised(Exception){@iso8601_date.year = 2008}
    assert_raise(ArgumentError){@iso8601_date.year = -1}
    assert_equal "2008", @iso8601_date.as_string
    assert_nothing_raised(Exception){@iso8601_date.month = 6}
    assert_equal 6, @iso8601_date.month
    assert_raise(ArgumentError){@iso8601_date.month = 13}
    assert_raise(ArgumentError){@iso8601_date.month = 0}
    assert !@iso8601_date.month_unknown?
    assert_equal "2008-06", @iso8601_date.as_string
    assert_nothing_raised(Exception){@iso8601_date.day = 14}
    assert_equal 14, @iso8601_date.day
    assert_raise(ArgumentError){@iso8601_date.day = 0}
    assert_raise(ArgumentError){@iso8601_date.day = 31}
    assert !@iso8601_date.day_unknown?
    assert !@iso8601_date.is_partial?
    assert_equal "2008-06-14", @iso8601_date.as_string
    assert OpenEHR::Assumed_Library_Types::ISO8601_DATE.valid_iso8601_date?("2006-06-14")
    assert !OpenEHR::Assumed_Library_Types::ISO8601_DATE.valid_iso8601_date?("ABCDEFG")
  end

  def test_iso8601_time
    assert_equal 15, @iso8601_time.hour
    assert_equal 55, @iso8601_time.minute
    assert_equal 37, @iso8601_time.second
    assert_equal 0.32, @iso8601_time.fractional_second
    assert_equal '+0900', @iso8601_time.timezone

#    assert_nothing_raised(Exception){@iso8601_time = OpenEHR::Assumed_Library_Types::ISO8601_TIME.new('15:55:37.32+0900')}

    assert_nothing_raised(Exception){@iso8601_time = OpenEHR::Assumed_Library_Types::ISO8601_TIME.new('01')}
    assert_equal 1, @iso8601_time.hour
    assert @iso8601_time.is_partial?
    assert_equal "01", @iso8601_time.as_string
    assert_raise(ArgumentError){@iso8601_time.hour = -1}
    assert_raise(ArgumentError){@iso8601_time.hour = 24}
    assert_nothing_raised(Exception){@iso8601_time.hour = 0}
    assert_equal 0, @iso8601_time.hour
    assert_equal "00", @iso8601_time.as_string
    assert_nothing_raised(Exception){@iso8601_time.hour = 23}
    assert_equal 23, @iso8601_time.hour
    assert_equal "23", @iso8601_time.as_string
    assert @iso8601_time.minute_unknown?
    assert @iso8601_time.second_unknown?
    assert !@iso8601_time.has_fractional_second?
    assert_raise(ArgumentError){@iso8601_time.fractional_second = 0.012}
    assert_raise(ArgumentError){@iso8601_time.second = 10}
    assert_raise(ArgumentError){@iso8601_time.minute = -1}
    assert_raise(ArgumentError){@iso8601_time.minute = 60}
    assert_nothing_raised(Exception){@iso8601_time.minute = 0}
    assert_equal 0, @iso8601_time.minute
    assert_equal "23:00", @iso8601_time.as_string
    assert_nothing_raised(Exception){@iso8601_time.minute = 59}
    assert_equal 59, @iso8601_time.minute
    assert_equal "23:59", @iso8601_time.as_string
    assert !@iso8601_time.minute_unknown?
    assert @iso8601_time.second_unknown?
    assert @iso8601_time.is_partial?
    assert_raise(ArgumentError){@iso8601_time.fractional_second = 0.012}
    assert_raise(ArgumentError){@iso8601_time.second = -1}
    assert_raise(ArgumentError){@iso8601_time.second = 60}
    assert_nothing_raised(Exception){@iso8601_time.second = 0}
    assert !@iso8601_time.second_unknown?
    assert_equal 0, @iso8601_time.second
    assert_equal "23:59:00", @iso8601_time.as_string
    assert_nothing_raised(Exception){@iso8601_time.second = 59}
    assert_equal 59, @iso8601_time.second
    assert_equal "23:59:59", @iso8601_time.as_string
    assert !@iso8601_time.is_partial?
    assert_raise(ArgumentError){@iso8601_time.fractional_second = 1.23}
    assert_nothing_raised(Exception){@iso8601_time.fractional_second = 0.23}
    assert @iso8601_time.has_fractional_second?
    assert_equal 0.23, @iso8601_time.fractional_second
    assert_equal "23:59:59.23", @iso8601_time.as_string
    assert @iso8601_time.is_extended?
    assert !@iso8601_time.is_decimal_sign_comma?
    assert OpenEHR::Assumed_Library_Types::ISO8601_TIME.valid_iso8601_time?("012345Z")
    assert OpenEHR::Assumed_Library_Types::ISO8601_TIME.valid_iso8601_time?("012345.67+0900")
    assert !OpenEHR::Assumed_Library_Types::ISO8601_TIME.valid_iso8601_time?("242345.67+0900")
    assert !OpenEHR::Assumed_Library_Types::ISO8601_TIME.valid_iso8601_time?("242345.67+0900")
    assert OpenEHR::Assumed_Library_Types::ISO8601_TIME.valid_iso8601_time?("240000")
    assert OpenEHR::Assumed_Library_Types::ISO8601_TIME.valid_iso8601_time?("240000Z")
    assert !OpenEHR::Assumed_Library_Types::ISO8601_TIME.valid_iso8601_time?("240000.011Z")
  end

  def test_iso_8601_date_time
    assert_equal 2009, @iso8601_date_time.year
    assert_equal 4, @iso8601_date_time.month
    assert_equal 27, @iso8601_date_time.day
    assert_equal 15, @iso8601_date_time.hour
    assert_equal 55, @iso8601_date_time.minute
    assert_equal 37, @iso8601_date_time.second
    assert_equal 0.32, @iso8601_date_time.fractional_second
    assert_equal '+0900', @iso8601_date_time.timezone
    assert_equal '2009-04-27T15:55:37.32+0900', @iso8601_date_time.as_string
    assert_nothing_raised(Exception){
      @iso8601_date_time.year = 2008 }
    assert_equal 2008, @iso8601_date_time.year
  end

  def test_iso8601_timezone
    @iso8601_timezone.sign = "+1"
    @iso8601_timezone.hour = 0
    @iso8601_timezone.minute = 0
    assert @iso8601_timezone.is_gmt?
    assert_equal "Z+0000", @iso8601_timezone.as_string
    @iso8601_timezone.hour = 9
    assert_equal "Z+0900", @iso8601_timezone.as_string
    assert !@iso8601_timezone.is_gmt?
    @iso8601_timezone.sign = "-1"
    @iso8601_timezone.hour = 4
    @iso8601_timezone.minute = 30
    assert_equal "Z-0430", @iso8601_timezone.as_string
  end

  def test_iso8601_duration
    assert_equal 1, @iso8601_duration.years
    assert_equal 2, @iso8601_duration.months
    assert_equal 3, @iso8601_duration.weeks
    assert_equal 4, @iso8601_duration.days
    assert_equal 5, @iso8601_duration.hours
    assert_equal 6, @iso8601_duration.minutes
    assert_equal 7, @iso8601_duration.seconds
    assert_equal 0.8, @iso8601_duration.fractional_second
    assert_equal 'P1Y2M3W4DT5H6M7.8S', @iso8601_duration.as_string
    assert_raise(ArgumentError){@iso8601_duration.years = -1}
    assert_nothing_raised(Exception){@iso8601_duration.years = nil}
    assert_nil @iso8601_duration.years
    assert_equal 'P2M3W4DT5H6M7.8S', @iso8601_duration.as_string
    assert_nothing_raised(Exception){@iso8601_duration.years = 2}
    assert_equal 2, @iso8601_duration.years
    assert_nothing_raised(Exception){@iso8601_duration.months = nil}
    assert_nil @iso8601_duration.months
    assert_equal 'P2Y3W4DT5H6M7.8S', @iso8601_duration.as_string
    assert_raise(ArgumentError){@iso8601_duration.months = -1}
    assert_nothing_raised(Exception){@iso8601_duration.months = 3}
    assert_equal 3, @iso8601_duration.months
    assert_nothing_raised(Exception){@iso8601_duration.weeks = nil}
    assert_nil @iso8601_duration.weeks
    assert_equal 'P2Y3M4DT5H6M7.8S', @iso8601_duration.as_string
    assert_raise(ArgumentError){@iso8601_duration.weeks = -1}
    assert_nothing_raised(Exception){@iso8601_duration.weeks = 1}
    assert_equal 'P2Y3M1W4DT5H6M7.8S', @iso8601_duration.as_string
    assert_raise(ArgumentError){@iso8601_duration.days = -1}
    assert_nothing_raised(Exception){@iso8601_duration.days = nil}
    assert_nil @iso8601_duration.days
    assert_equal 'P2Y3M1WT5H6M7.8S', @iso8601_duration.as_string
    assert_nothing_raised(Exception){@iso8601_duration.hours = nil}
    assert_nil @iso8601_duration.hours
    assert_equal 'P2Y3M1W', @iso8601_duration.as_string
    assert_raise(ArgumentError){@iso8601_duration.hours = -1}
    assert_nothing_raised(Exception){@iso8601_duration.hours = 5}
    assert_equal 5, @iso8601_duration.hours
    assert_equal 'P2Y3M1WT5H6M7.8S', @iso8601_duration.as_string
    assert_raise(ArgumentError){@iso8601_duration.minutes = -1}
    assert_nothing_raised(Exception){@iso8601_duration.minutes = nil}
    assert_nil @iso8601_duration.minutes
    assert_equal 'P2Y3M1WT5H', @iso8601_duration.as_string
    assert_nothing_raised(Exception){@iso8601_duration.minutes = 0}
    assert_equal 0, @iso8601_duration.minutes
    assert_equal 'P2Y3M1WT5H0M7.8S', @iso8601_duration.as_string
    assert_raise(ArgumentError){@iso8601_duration.seconds = -1}
    assert_nothing_raised(Exception){@iso8601_duration.seconds = nil}
    assert_nil @iso8601_duration.seconds
    assert_equal 'P2Y3M1WT5H0M', @iso8601_duration.as_string
    assert_nothing_raised(Exception){@iso8601_duration.seconds = 10}
    assert_equal 10, @iso8601_duration.seconds
    assert_equal 'P2Y3M1WT5H0M10.8S', @iso8601_duration.as_string
    assert_raise(ArgumentError){@iso8601_duration.fractional_second = 1.0}
    assert_raise(ArgumentError){@iso8601_duration.fractional_second = -0.1}
    assert_nothing_raised(Exception){@iso8601_duration.fractional_second = nil}
    assert_nil @iso8601_duration.fractional_second
    assert_equal 'P2Y3M1WT5H0M10S', @iso8601_duration.as_string
    assert_nothing_raised(Exception){@iso8601_duration.fractional_second = 0.2}
    assert_equal 0.2, @iso8601_duration.fractional_second
    assert_equal 'P2Y3M1WT5H0M10.2S', @iso8601_duration.as_string
  end
end
