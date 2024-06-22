# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :authorize_admin
  before_action :find_product, only: %i[update destroy change_state]
  before_action :find_client, only: :assign_products_to_client

  def create
    product = Product.new(product_params)

    if product.save
      ActionLogger.log_action(@current_user, 'Product created', product)
      render json: product, status: :created
    else
      render json: product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      ActionLogger.log_action(@current_user, 'Product updated', @product)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @product.destroy
      ActionLogger.log_action(@current_user, 'Product deleted', @product)
      head :no_content
    else
      render json: { error: 'Failed to delete the record' }, status: :unprocessable_entity
    end
  end

  def change_state
    if @product.update(state: product_params[:state])
      ActionLogger.log_action(@current_user, 'Product state changed', @product)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def assign_products_to_client
    unassigned_products = []

    products_to_assign&.each do |product_id|
      client_product = ClientProduct.new(user_id: @client.id, product_id:)
      if client_product.save
        ActionLogger.log_action(@current_user, 'Product assigned to client', client_product)
      else
        unassigned_products << client_product.errors
      end
    end

    render json: { message: 'Products assigned.', unassigned_products: }, status: :created
  end

  private

  def find_product
    @product = Product.find_by_id(params[:id])
    render_not_found_error unless @product
  end

  def find_client
    @client = User.find_by_id(products_params[:user_id])
    render_not_found_error unless @client
  end

  def products_to_assign
    products_params[:product_ids]
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :state, :brand_id)
  end

  def products_params
    params.require(:products).permit(:user_id, product_ids: [])
  end
end
