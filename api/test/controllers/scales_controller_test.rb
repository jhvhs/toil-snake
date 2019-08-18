require 'test_helper'

class ScalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @scale = scales(:one)
  end

  test "should get index" do
    get scales_url, as: :json
    assert_response :success
  end

  test "should create scale" do
    assert_difference('Scale.count') do
      post scales_url, params: { scale: { author: @scale.author, details: @scale.details, snake_id: @scale.snake_id } }, as: :json
    end

    assert_response 201
  end

  test "should show scale" do
    get scale_url(@scale), as: :json
    assert_response :success
  end

  test "should update scale" do
    patch scale_url(@scale), params: { scale: { author: @scale.author, details: @scale.details, snake_id: @scale.snake_id } }, as: :json
    assert_response 200
  end

  test "should destroy scale" do
    assert_difference('Scale.count', -1) do
      delete scale_url(@scale), as: :json
    end

    assert_response 204
  end
end
