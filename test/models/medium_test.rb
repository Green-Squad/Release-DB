require 'test_helper'

class MediumTest < ActiveSupport::TestCase
  def setup
    @one = media(:one)
  end
  
  test "should not create medium" do
    assert_no_difference('Medium.count') do
      Medium.create(name: "")
    end
  end

  test "should not update medium" do
    name = @one.name
    @one.update_attributes(name: "")
    assert_equal name, Medium.find(media(:one)).name
  end
end
