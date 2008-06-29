require 'test/unit'
require 'assumed_library_types.rb'

class Assumed_Library_Test < Test::Unit::TestCase
  def setup
    @interval = OpenEHR::Assumed_Library_Types::Interval.new(1,2)
    @time_definition = OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.new
    @iso8601_date = OpenEHR::Assumed_Library_Types::ISO8601_DATE.new
    @iso8601_time = OpenEHR::Assumed_Library_Types::ISO8601_TIME.new
  end
  def test_initialize
    assert_instance_of OpenEHR::Assumed_Library_Types::Interval, @interval
    assert_instance_of OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS, @time_definition
    assert_instance_of OpenEHR::Assumed_Library_Types::ISO8601_DATE, @iso8601_date
    assert_instance_of OpenEHR::Assumed_Library_Types::ISO8601_TIME, @iso8601_time
  end
  def test_limits_comparable
    assert @interval.lower < @interval.upper
    @interval.set_lower(1.0)
    @interval.set_upper(2.0)
    assert @interval.lower < @interval.upper
  end
  def test_limits_consistent
    assert @interval.has?(1.5)
    assert !@interval.has?(3.0)
    assert !@interval.has?(0.5)
    @interval.set_lower_included(true)
    assert @interval.has?(1.0)
    @interval.set_lower_included(false)
    assert !@interval.has?(1.0)
    @interval.set_upper_included(true)
    assert @interval.has?(2.0)
    @interval.set_upper_included(false)
    assert !@interval.has?(2.0)
  end
  def test_lower_included_valid
    @interval.set_lower(nil)
    assert @interval.lower_unbounded
    assert !@interval.lower_included
    @interval.set_lower(1.0)
  end
  def test_upper_included_valid
    @interval.set_upper(nil)
    assert @interval.upper_unbounded
    assert !@interval.upper_included
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

  def test_date_time_valid
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
    assert @iso8601_date.day_unknown?
    assert @iso8601_date.month_unknown?
    assert @iso8601_date.is_partial?
    assert @iso8601_date.is_extended?
    @iso8601_date.year = 2008
    assert_equal 2008, @iso8601_date.year 
    assert_raise(ArgumentError){@iso8601_date.year = -1}
    assert_equal "2008", @iso8601_date.as_string
    @iso8601_date.month = 6
    assert_equal 6, @iso8601_date.month
    assert_raise(ArgumentError){@iso8601_date.month = 13}
    assert_raise(ArgumentError){@iso8601_date.month = 0}
    assert !@iso8601_date.month_unknown?
    assert_equal "2008-06", @iso8601_date.as_string
    @iso8601_date.day = 14
    assert_equal 14, @iso8601_date.day
    assert_raise(ArgumentError){@iso8601_date.day = 0}
    assert_raise(ArgumentError){@iso8601_date.day = 31}
    assert !@iso8601_date.day_unknown?
    assert !@iso8601_date.is_partial?
    assert_equal "2008-06-14", @iso8601_date.as_string
    assert @iso8601_date.valid_iso8601_date("2006-06-14")
    assert !@iso8601_date.valid_iso8601_date("ABCDEFG")
  end

  def test_iso8601_time
    assert @iso8601_time.
  end
end
