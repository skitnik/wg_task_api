# frozen_string_literal: true

class CatalogsController < ApplicationController
  before_action :authorize_client

  def index
    render json: products, status: :ok
  end

  private

  def products
    products = @current_user.products.active
    products = products.where(brand_id: catalog_params[:brand_id]) if catalog_params[:brand_id]
    if catalog_params[:product_name]
      products = products.where('products.name LIKE ?',
                                "%#{catalog_params[:product_name]}%")
    end
    products.paginate(per_page: 20, page: products_page)
  end

  def products_page
    catalog_params[:page].nil? ? 1 : catalog_params[:page].to_i
  end

  def catalog_params
    params.fetch(:catalog, {}).permit(:brand_id, :product_name, :page)
  end
end
