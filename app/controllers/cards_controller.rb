# frozen_string_literal: true

class CardsController < ApplicationController
  before_action :authorize_client
  before_action :find_card, only: :cancel

  def create
    card = Card.new(card_params.merge(user_id: @current_user.id, purchase_details:))
    if card.save
      ActionLogger.log_action(@current_user, 'Card created', card)
      render json: card, status: :created
    else
      render json: card.errors, status: :unprocessable_entity
    end
  end

  def cancel
    if @card.update(status: 'canceled')
      ActionLogger.log_action(@current_user, 'Card cancelled', @card)
      render json: @card
    else
      render json: @card.errors, status: :unprocessable_entity
    end
  end

  private

  def find_card
    @card = Card.requested.find_by_id(params[:card_id])
    render_not_found_error unless @card
  end

  def purchase_details
    product = Product.find_by_id(card_params[:product_id])
    "Product: #{product&.name}, Price: #{product&.price}, Brand: #{product&.brand&.name}"
  end

  def card_params
    params.require(:card).permit(:product_id)
  end
end
