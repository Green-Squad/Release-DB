require 'test_helper'

class LaunchDateTest < ActiveSupport::TestCase
  def setup
    @one = launch_dates(:one)
  end
  
  test "should not create launch date" do
    assert_no_difference('LaunchDate.count') do
      LaunchDate.create(launch_date: "")
    end
  end
  
    test "should not create duplicate launch date" do
    assert_difference('LaunchDate.count', 1) do
      LaunchDate.create(launch_date: "January 22, 2015")
    end
    assert_no_difference('LaunchDate.count') do
      LaunchDate.create(launch_date: "JaNuArY 22, 2015")
    end
  end

  test "should not update launch date" do
    launch_date = @one.launch_date
    @one.update_attributes(launch_date: "")
    assert_equal launch_date, LaunchDate.find(launch_dates(:one)).launch_date
  end
end
