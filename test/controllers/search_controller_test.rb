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
    # &#39; = single quote (') 
    # The view wraps '' around the query, but the assert_select failed without specifying the single quote
    assert_select "&#39;Unique string that is not in the database&#39;"
  end
end
