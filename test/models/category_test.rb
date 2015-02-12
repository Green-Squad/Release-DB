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
  
  test "should return categories in a sentence" do
    categories = Category.all
    sentence = Category.sentence
    categories.each do |category|
      assert sentence.include? category.name
    end
    
    assert_equal categories.count - 1, sentence.count(",")
    assert sentence.include? "and"
  end
end
