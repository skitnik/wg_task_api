# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :authorize_admin, only: %i[brand_report client_report]
  before_action :authorize_client, only: :client_transactions_report
  before_action :find_brand, only: :brand_report
  before_action :find_client, only: :client_report

  def brand_report
    ActionLogger.log_action(@current_user, 'Report generated for brand', @brand)
    render json: { brand: @brand, products: @brand.products }, status: :ok
  end

  def client_report
    client_data = {
      email: @client.email,
      role: @client.role,
      payout_rate: @client.payout_rate
    }

    ActionLogger.log_action(@current_user, 'Report generated for client', @client)
    render json: { client: client_data, products: @client.products }, status: :ok
  end

  def client_transactions_report
    ActionLogger.log_action(@current_user, 'Report generated for client transactions', @current_user)
    render json: { activated_transactions: activated_transactions_details,
                   canceled_transactions: canceled_transactions_details },
           status: :ok
  end

  private

  def find_brand
    @brand = Brand.find_by_id(report_params[:brand_id])
    render_not_found_error unless @brand
  end

  def find_client
    @client = User.find_by_id(report_params[:client_id])
    render_not_found_error unless @client
  end

  def client_cards
    @client_cards ||= Card.where(user_id: @current_user)
  end

  def activated_transactions_details
    client_cards.activated.map do |card|
      {
        id: card.id,
        details: card.purchase_details,
        created_at: card.created_at
      }
    end
  end

  def canceled_transactions_details
    client_cards.canceled.map do |card|
      {
        id: card.id,
        details: card.purchase_details,
        created_at: card.created_at
      }
    end
  end

  def report_params
    params.require(:report).permit(:brand_id, :client_id)
  end
end
