require 'test_helper'

class RegionsControllerTest < ActionController::TestCase
  setup do
    @region = regions(:one)
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:regions)
  end
end
