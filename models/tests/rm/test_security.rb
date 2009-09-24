require 'test/unit'
require 'rm'

class RM_Security_Test < Test::Unit::TestCase
  def setup
    assert_nothing_raised(Exception){
      @access_control_setting = OpenEhr::RM::Security::AccessControlSettings.new}
  end

  def test_init
    assert_instance_of OpenEhr::RM::Security::AccessControlSettings, @access_control_setting
  end
end
