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
    assert_equal launch_date, LaunchDate.find(launch_dates(:one).id).launch_date
  end
  
  test "should get ruby date object" do
    # All of the dates should equal February 11, 2015
    date = Date.parse("2015-02-11")
    
    launch_date = LaunchDate.create(launch_date: "2015-02-11")
    assert_equal date, launch_date.date
    
    launch_date = LaunchDate.create(launch_date: "Feb 11, 2015")
    assert_equal date, launch_date.date
    
    launch_date = LaunchDate.create(launch_date: "February 11, 2015")
    assert_equal date, launch_date.date
    
    launch_date = LaunchDate.create(launch_date: "2015/02/11")
    assert_equal date, launch_date.date

    launch_date = LaunchDate.create(launch_date: "Feb 11 2015")
    assert_equal date, launch_date.date
  end
  
  test "should get ruby date object from beginning of time" do
    launch_date = LaunchDate.create(launch_date: "Fake Date")
    date = Date.parse("-9999999-01-01")
    assert_equal date, launch_date.date
  end
end
