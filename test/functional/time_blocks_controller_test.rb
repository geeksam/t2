require 'test_helper'

class TimeBlocksControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:time_blocks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create time_block" do
    assert_difference('TimeBlock.count') do
      post :create, :time_block => { }
    end

    assert_redirected_to time_block_path(assigns(:time_block))
  end

  test "should show time_block" do
    get :show, :id => time_blocks(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => time_blocks(:one).to_param
    assert_response :success
  end

  test "should update time_block" do
    put :update, :id => time_blocks(:one).to_param, :time_block => { }
    assert_redirected_to time_block_path(assigns(:time_block))
  end

  test "should destroy time_block" do
    assert_difference('TimeBlock.count', -1) do
      delete :destroy, :id => time_blocks(:one).to_param
    end

    assert_redirected_to time_blocks_path
  end
end