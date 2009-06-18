require 'test/unit'
require 'rm'

class RM_Security_Test < Test::Unit::TestCase
  def setup
    assert_nothing_raised(Exception){
      @access_control_setting = OpenEHR::RM::Security::Access_Control_Settings.new}
  end

  def test_init
    assert_instance_of OpenEHR::RM::Security::Access_Control_Settings, @access_control_setting
  end
end
