require 'test_helper'

class ProductsControllerTest < ActionController::TestCase
  setup do
    @product = products(:one)
    @admin_user = admin_users(:admin_user)
    @json = { "name" => "name", "value" => "Halo 3" }.to_json
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:products)
  end
  
  #test "should rollback create product as guest" do
  #  assert_no_difference('Product.count') do
  #    post :create, product: { name: "Halo 2", category_id: categories(:one).id }
  #  end
  #end

  #test "should create product as admin" do
  #  sign_in @admin_user
  #  assert_difference('Product.count') do
  #    post :create, product: { name: "Halo 2", category_id: categories(:one).id }
  #  end
  #end

  test "should show product" do
    get :show, id: @product
    assert_response :success
  end

  test "should rollback update product as guest" do
    #patch :update, id: @product, product: { name: "Halo 3", category_id: categories(:one) }.to_json, format: :json
    #assert_equal "Halo", Product.find(products(:one)).name
  end
  
  test "should update product as admin" do
    sign_in @admin_user
    #patch :update, id: @product.id, @json
    #assert_response :success
    #assert_equal "Halo 3", Product.find(products(:one)).name
    #assert_equal 'application/json', response.headers['Content-Type']
  end

  #test "should not create product" do
  #  assert_no_difference('Product.count') do
  #    post :create, product: { name: "", category_id: categories(:one).id }
  #  end
  #end

  test "should not update product" do
    patch :update, id: @product, product: { name: "" }.to_json, format: :json
    assert_equal "Halo", Product.find(products(:one).id).name
  end
end