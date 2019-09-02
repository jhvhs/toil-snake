# frozen_string_literal: true

class SnakesController < ApplicationController
  before_action :set_snake, only: %i[show update destroy]

  # GET /snakes
  def index
    @snakes = Snake.includes(:scales).all

    render json: @snakes.to_json(include: :scales)
  end

  # GET /snakes/1
  def show
    render json: @snake
  end

  # POST /snakes
  def create
    @snake = Snake.new(snake_params)

    if @snake.save
      render json: @snake, status: :created, location: @snake
    else
      render json: @snake.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /snakes/1
  def update
    if @snake.update(snake_params)
      render json: @snake
    else
      render json: @snake.errors, status: :unprocessable_entity
    end
  end

  # DELETE /snakes/1
  def destroy
    @snake.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_snake
    @snake = Snake.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def snake_params
    params.require(:snake).permit(:title, :author)
  end
end
