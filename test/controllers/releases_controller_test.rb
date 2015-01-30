require 'test_helper'

class ReleasesControllerTest < ActionController::TestCase
  setup do
    @release = releases(:one)
    @admin_user = admin_users(:admin_user)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:releases)
  end
  
  test "should rollback create release as guest" do
    assert_no_difference('Release.count') do
      post :create, { product_id: products(:one).id, launch_date: "asdfasdf", medium_id: media(:one).id, region_id: regions(:one).id, source: "bing.com"}
    end
  end

  test "should create release as admin" do
    sign_in @admin_user
    assert_difference('Release.count') do
      post :create, { product_id: products(:one).id, launch_date: "asdfasdf", medium_id: media(:one).id, region_id: regions(:one).id, source: "bing.com"}
    end
  end

  test "should show release" do
    get :show, id: @release
    assert_response :success
  end

  test "should update release as admin" do
    #sign_in @admin_user
    #put :update, id: @release, "{ \"name\": \"lol\"   }", format: :json
    #put release_path(id: @release.id), { name: "source", value: "amazon.com" }, format: :json
    #assert_equal "amazon.com", Release.find(releases(:one)).source
  end
  
  test "should rollback update release as guest" do
    #patch "/releases/#{@release.id}", { name: "source", value: "amazon.com" }, format: :json
    #assert_equal "google.com", Release.find(releases(:one)).source
  end

  test "should destroy release" do
    assert_difference('Release.count', -1) do
      delete :destroy, id: @release
    end

    assert_redirected_to releases_path
  end
end
