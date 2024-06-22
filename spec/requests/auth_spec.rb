# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Auth', type: :request do
  let(:valid_credentials) { { email: 'admin@example.com', password: 'password' } }
  let(:invalid_credentials) { { email: 'test@example.com', password: 'invalid' } }

  before { create(:user, :admin) }

  describe 'POST /auth/login' do
    context 'when the request is valid' do
      it 'returns an authentication token' do
        expect(ActionLogger).to receive(:log_action)
        post('/auth/login', params: valid_credentials)

        expect(json['token']).not_to be_nil
        decoded_token = JsonWebToken.decode(json['token'])
        expect(decoded_token[:user_id]).to eq(User.last.id)
      end
    end

    context 'when the request is invalid' do
      before { post '/auth/login', params: invalid_credentials }

      it 'returns an error message' do
        expect(json['error']).to match(/Invalid email or password/)
      end
    end
  end

  describe 'POST /auth/signup' do
    let(:valid_attributes) { { email: 'newuser@example.com', password: 'password', password_confirmation: 'password' } }

    context 'when the request is valid' do
      it 'creates new user and returns an authentication token' do
        expect(ActionLogger).to receive(:log_action)

        post('/auth/signup', params: valid_attributes)

        expect(User.count).to eq(2)
        expect(json['token']).not_to be_nil
        decoded_token = JsonWebToken.decode(json['token'])
        expect(decoded_token[:user_id]).to eq(User.last.id)
      end
    end

    context 'when the request is invalid' do
      before do
        post '/auth/signup',
             params: { email: 'newuser@example.com', password: 'password', password_confirmation: 'wrong' }
      end

      it 'returns a validation failure message' do
        expect(json['errors']).to include("Password confirmation doesn't match Password")
      end
    end
  end
end
