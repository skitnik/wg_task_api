# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :authorize_admin, only: :create

  def create
    client = User.new(client_params.merge(role: 'client'))

    if client.save
      ActionLogger.log_action(@current_user, 'Client created', client)
      render json: client, status: :created
    else
      render json: { errors: client.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def client_params
    params.require(:client).permit(:email, :password, :password_confirmation, :payout_rate)
  end
end
