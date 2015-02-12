require 'test_helper'

class RegionTest < ActiveSupport::TestCase
  def setup
    @one = regions(:one)
  end
  
  test "should not create region" do
    assert_no_difference('Region.count') do
      Region.create(name: "")
    end
  end

  test "should not update region" do
    name = @one.name
    @one.update_attributes(name: "")
    assert_equal name, Region.find(regions(:one).id).name
  end
end
