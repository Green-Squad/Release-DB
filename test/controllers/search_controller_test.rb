require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should redirect root with no search param" do
    get :search, search: nil
    assert_redirected_to root_url
  end
  
  test "should redirect to product" do
        get :search, search: "Halo"
        product = Product.where("name LIKE 'Halo%'").first
        assert_redirected_to product_url(product)
  end

  test "should get search" do
    get :search, search: "Unique string that is not in the database"
    assert_template 'search/index'
  end
end
