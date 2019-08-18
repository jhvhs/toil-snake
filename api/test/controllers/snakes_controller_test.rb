require 'test_helper'

class SnakesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @snake = snakes(:one)
  end

  test "should get index" do
    get snakes_url, as: :json
    assert_response :success
  end

  test "should create snake" do
    assert_difference('Snake.count') do
      post snakes_url, params: { snake: { title: @snake.title } }, as: :json
    end

    assert_response 201
  end

  test "should show snake" do
    get snake_url(@snake), as: :json
    assert_response :success
  end

  test "should update snake" do
    patch snake_url(@snake), params: { snake: { title: @snake.title } }, as: :json
    assert_response 200
  end

  test "should destroy snake" do
    assert_difference('Snake.count', -1) do
      delete snake_url(@snake), as: :json
    end

    assert_response 204
  end
end
