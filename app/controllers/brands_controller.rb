# frozen_string_literal: true

class BrandsController < ApplicationController
  before_action :authorize_admin
  before_action :find_brand, only: %i[update change_state]

  def create
    brand = Brand.new(brand_params)

    if brand.save
      ActionLogger.log_action(@current_user, 'Brand created', brand)
      render json: brand, status: :created
    else
      render json: brand.errors, status: :unprocessable_entity
    end
  end

  def update
    if @brand.update(brand_params)
      ActionLogger.log_action(@current_user, 'Brand updated', @brand)
      render json: @brand
    else
      render json: @brand.errors, status: :unprocessable_entity
    end
  end

  def change_state
    if @brand.update(state: brand_params[:state])
      ActionLogger.log_action(@current_user, 'Brand state changed', @brand)
      render json: @brand
    else
      render json: @brand.errors, status: :unprocessable_entity
    end
  end

  private

  def find_brand
    @brand = Brand.find_by_id(params[:id])
    render_not_found_error unless @brand
  end

  def brand_params
    params.require(:brand).permit(:name, :description, :state)
  end
end
