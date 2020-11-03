# frozen_string_literal: true

require 'test_helper'

class ScalesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @snake = snakes(:one)
    @scale = scales(:one)
  end

  test 'should get index' do
    get snake_scales_url(@snake), as: :json
    assert_response :success
  end

  test 'should create scale' do
    assert_difference('Scale.count') do
      post snake_scales_url(@snake), params: { scale: { author: @scale.author, details: @scale.details } }, as: :json
    end

    assert_response 201
  end

  test 'should show scale' do
    get snake_scale_url(@scale.snake, @scale), as: :json
    assert_response :success
  end

  test 'should update scale' do
    patch snake_scale_url(@scale.snake, @scale), params: { scale: { author: @scale.author, details: @scale.details, snake_id: @scale.snake_id } }, as: :json
    assert_response 200
  end

  test 'should destroy scale' do
    assert_difference('Scale.count', -1) do
      delete snake_scale_url(@scale.snake, @scale), as: :json
    end

    assert_response 204
  end
end
