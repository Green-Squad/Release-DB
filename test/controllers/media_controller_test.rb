require 'test_helper'

class MediaControllerTest < ActionController::TestCase
  setup do
    @medium = media(:one)
  end

  test "should get index" do
    get :index, :format => :json
    assert_response :success
    assert_not_nil assigns(:media)
  end
end
