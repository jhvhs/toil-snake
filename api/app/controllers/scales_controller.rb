# frozen_string_literal: true

class ScalesController < ApplicationController
  before_action :set_scale, only: %i[show update destroy]

  # GET /scales
  def index
    @scales = Scale.all

    render json: @scales
  end

  # GET /scales/1
  def show
    render json: @scale
  end

  # POST /scales
  def create
    @scale = Scale.new(scale_params)

    if @scale.save
      render json: @scale, status: :created, location: @scale
    else
      render json: @scale.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /scales/1
  def update
    if @scale.update(scale_params)
      render json: @scale
    else
      render json: @scale.errors, status: :unprocessable_entity
    end
  end

  # DELETE /scales/1
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
    params.require(:scale).permit(:snake_id, :author, :details)
  end
end
