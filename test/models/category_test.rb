require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  
  def setup
    @one = categories(:one)
  end
  
  test "should not create category" do
    assert_no_difference('Category.count') do
      Category.create(name: "")
    end
  end

  test "should not update category" do
    name = @one.name
    @one.update_attributes(name: "")
    assert_equal name, Category.find(categories(:one).id).name
  end
end
