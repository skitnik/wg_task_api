# frozen_string_literal: true

module AuthorizeRequest
  extend ActiveSupport::Concern

  included do
    before_action :authorize_request
  end

  private

  def authorize_request
    header = request.headers['Authorization']
    header = header.split(' ').last if header
    begin
      @decoded = JsonWebToken.decode(header)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound => e
      render json: { errors: e.message }, status: :unauthorized
    rescue StandardError => e
      render json: { errors: e.message }, status: :unauthorized
    end
  end

  def authorize_admin
    render json: { error: 'Not Authorized' }, status: 403 unless @current_user.admin?
  end

  def authorize_client
    render json: { error: 'Not Authorized' }, status: 403 unless @current_user.client?
  end
end
