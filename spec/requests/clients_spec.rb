# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Clients', type: :request do
  let(:user) { create(:user, :admin) }
  let(:headers) { { 'Authorization' => JsonWebToken.encode(user_id: user.id) } }
  let(:valid_credentials) do
    { email: 'client@example.com', password: 'password', password_confirmation: 'password', payout_rate: 5.0 }
  end
  let(:invalid_credentials) { { email: 'client@example.com', password: 'password', password_confirmation: 'wrong' } }

  describe 'POST /clients' do
    context 'when the request is valid' do
      it 'creates a new client' do
        expect(ActionLogger).to receive(:log_action)

        post('/clients', params: { client: valid_credentials }, headers:)

        expect(User.count).to eq(2)
      end
    end

    context 'when the request is invalid' do
      before { post '/clients', params: { client: invalid_credentials }, headers: }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns an error message' do
        expect(json['errors']).to include("Password confirmation doesn't match Password")
      end
    end
  end
end
