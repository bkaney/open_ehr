require 'test/unit'
require 'assumed_library_types.rb'

class Assumed_Library_Test < Test::Unit::TestCase
  def setup
    @interval = OpenEHR::Assumed_Library_Types::Interval.new(1,2)
  end
  def test_initialize
    assert_instance_of OpenEHR::Assumed_Library_Types::Interval, @interval
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
end
