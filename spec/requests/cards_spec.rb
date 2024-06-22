# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CardsController, type: :request do
  let!(:client) { create(:user, :client) }
  let(:headers) { { 'Authorization' => JsonWebToken.encode(user_id: client.id) } }
  let!(:admin) { create(:user, :admin) }
  let(:admin_headers) { { 'Authorization' => JsonWebToken.encode(user_id: admin.id) } }
  let(:brand) { create(:brand) }
  let(:product) { create(:product, brand:) }
  let!(:card) { create(:card, user: client, product:) }

  describe 'GET #create' do
    context 'when the request is valid' do
      it 'creates a card' do
        expect(ActionLogger).to receive(:log_action)

        post('/cards', params: { card: { product_id: product.id } }, headers:)

        expect(response).to have_http_status(201)
        expect(json['product_id']).to eq(product.id)
        expect(json['user_id']).to eq(client.id)
        expect(json['pin']).not_to be_nil
        expect(json['activation_number']).not_to be_nil
        expect(json['purchase_details']).not_to be_nil
        expect(json['status']).to eq('requested')
      end
    end

    context 'when the request is invalid' do
      it 'returns a 403 status when the user is not a client' do
        post('/cards', headers: admin_headers)

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'PATCH #cancel' do
    context 'when the request is valid' do
      it 'cancels a card' do
        expect(ActionLogger).to receive(:log_action)

        patch("/cards/#{card.id}/cancel", headers:)
        expect(response).to have_http_status(200)
        expect(json['status']).to eq('canceled')
      end
    end

    context 'when the request is invalid' do
      before { card.update(status: 'activated') }

      it 'returns a 403 status when the user is not a client' do
        patch("/cards/#{card.id}/cancel", headers: admin_headers)

        expect(response).to have_http_status(:forbidden)
      end

      it 'returns a 404 status when the card has different status than requested' do
        patch("/cards/#{card.id}/cancel", headers:)
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when the record does not exists' do
      it 'returns status code 404' do
        patch("/cards/#{card.id + 1}/cancel", headers:)
        expect(response).to have_http_status(404)
      end
    end
  end
end
