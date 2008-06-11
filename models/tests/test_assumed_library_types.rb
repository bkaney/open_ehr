require 'test/unit'
require 'assumed_library_types.rb'

class Assumed_Library_Test < Test::Unit::TestCase
  def setup
    @interval = OpenEHR::Assumed_Library_Types::Interval.new(1,2)
    @time_definition = OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS.new
  end
  def test_initialize
    assert_instance_of OpenEHR::Assumed_Library_Types::Interval, @interval
    assert_instance_of OpenEHR::Assumed_Library_Types::TIME_DEFINITIONS, @time_definition
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
  def test_definitions
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
end
