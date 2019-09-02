# frozen_string_literal: true

class ScalesController < ApplicationController
  before_action :set_scale, only: %i[show update destroy]

  # GET /snakes/:snake_id/scales
  def index
    @scales = Scale.all

    render json: @scales
  end

  # GET /snakes/:snake_id/scales/1
  def show
    render json: @scale
  end

  # POST /snakes/:snake_id/scales
  def create
    @scale = Scale.new(scale_params)

    if @scale.save
      render json: @scale, status: :created
    else
      render json: @scale.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /snakes/:snake_id/scales/1
  def update
    if @scale.update(scale_params)
      render json: @scale
    else
      render json: @scale.errors, status: :unprocessable_entity
    end
  end

  # DELETE /snakes/:snake_id/scales/1
  def destroy
    @scale.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_scale
    @scale = Scale.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def scale_params
    params.require(:scale).permit(:author, :details).merge(snake_id: params[:snake_id])
  end
end
