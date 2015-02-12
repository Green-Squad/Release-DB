require 'test_helper'

class ReleaseTest < ActiveSupport::TestCase
  def setup
    @one = releases(:one)
  end
  
  test "should not create release" do
    assert_no_difference('Release.count') do
      Release.create()
    end
  end

  test "should not update release" do
    release_one = @one.attributes
    @one.update_attributes(product: nil, launch_date_id: "", medium_id: "", region_id: "")
    assert_equal release_one, Release.find(releases(:one).id).attributes
  end
end
