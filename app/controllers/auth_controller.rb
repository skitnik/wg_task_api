# frozen_string_literal: true

class AuthController < ApplicationController
  def login
    user = User.find_by(email: user_params[:email])
    if user&.authenticate(params[:password])
      ActionLogger.log_action(user, 'User logged in', user)
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def signup
    user = User.new(user_params.merge(role: :admin))

    if user.save
      ActionLogger.log_action(user, 'Admin created', user)
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:email, :password, :password_confirmation)
  end
end
