require 'test/unit'
require 'rm'
include OpenEhr::RM::DataTypes::Quantity::DateTime

class DateTimeTest < Test::Unit::TestCase
  def setup
    assert_nothing_raised(Exception){
      @dv_temporal = DvTemporal.new('2008')}
    assert_nothing_raised(Exception){
      @dv_date = DvDate.new('2009-06-29')}
    assert_nothing_raised(Exception){
      @dv_time = DvTime.new('12:34:56.78')}
    assert_nothing_raised(Exception){
      @dv_date_time = DvDateTime.new('2009-06-29T12:34:56.78')}
    assert_nothing_raised(Exception){
      @dv_duration = DvDuration.new('P1Y2M3W4DT5H6M7.8S')}
  end

  def test_init
    assert_instance_of DvTemporal, @dv_temporal
    assert_instance_of DvDate, @dv_date
    assert_instance_of DvTime, @dv_time
    assert_instance_of DvDateTime, @dv_date_time
    assert_instance_of DvDuration, @dv_duration
  end

  def test_dv_temporal
    assert_equal '2008', @dv_temporal.value
    assert_raise(NotImplementedError){@dv_temporal.diff('2009')}
  end

  def test_dv_date
    assert_equal '2009-06-29', @dv_date.value
    assert_equal 2009, @dv_date.year
    assert_equal 6, @dv_date.month
    assert_equal 29, @dv_date.day
    assert_equal 733954, @dv_date.magnitude
    date2 = DvDate.new('2009-07-08')
    assert_equal 'P0Y0M1W9D',@dv_date.diff(date2).value
    date2 = DvDate.new('2004-02-28')
    date3 = DvDate.new('2004-03-01')
    assert_equal 'P0Y0M0W2D', date2.diff(date3).value
    date4 = DvDate.new('2003-12-31')
    assert_equal 'P0Y1M4W28D', date2.diff(date4).value
    birthday = DvDate.new('1970-04-19')
    assert_equal 'P39Y2M1W11D', birthday.diff(DvDate.new('2009-06-30')).value
  end

  def test_dv_time
    assert_equal '12:34:56.78', @dv_time.value
    assert_equal 12, @dv_time.hour
    assert_equal 34, @dv_time.minute
    assert_equal 56, @dv_time.second
    assert_equal 0.78, @dv_time.fractional_second
    assert_equal((12*60*60 + 34 * 60 + 56 + 0.78), @dv_time.magnitude)
    dv_time2 = DvTime.new('15:36:48.05')
    assert_equal 'P0Y0M0W0DT3H1M51.27S', @dv_time.diff(dv_time2).value
  end

  def test_dv_date_time
    assert_equal '2009-06-29T12:34:56.78', @dv_date_time.value
    assert_equal 2009, @dv_date_time.year
    assert_equal 6, @dv_date_time.month
    assert_equal 29, @dv_date_time.day
    assert_equal 12, @dv_date_time.hour
    assert_equal 34, @dv_date_time.minute
    assert_equal 56, @dv_date_time.second
    assert_equal 0.78, @dv_date_time.fractional_second
    dv_date_time2 = DvDateTime.new('1970-04-19T13:55:30.12')
    assert_equal 'P39Y2M1W9DT22H39M26.66S', @dv_date_time.diff(dv_date_time2).value
  end

  def test_dv_duration
    assert_equal 'P1Y2M3W4DT5H6M7.8S', @dv_duration.value
    assert_equal 1, @dv_duration.years
    assert_equal 2, @dv_duration.months
    assert_equal 3, @dv_duration.weeks
    assert_equal 4, @dv_duration.days
    assert_equal 5, @dv_duration.hours
    assert_equal 6, @dv_duration.minutes
    assert_equal 7, @dv_duration.seconds
    assert_equal 0.8, @dv_duration.fractional_second
  end
end
