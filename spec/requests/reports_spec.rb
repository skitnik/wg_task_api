# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', type: :request do
  let(:admin) { create(:user, :admin) }
  let(:client) { create(:user, :client) }
  let(:headers_admin) { { 'Authorization' => JsonWebToken.encode(user_id: admin.id) } }
  let(:headers_client) { { 'Authorization' => JsonWebToken.encode(user_id: client.id) } }

  let(:brand) { create(:brand, state: :active) }
  let!(:products) { create_list(:product, 3, brand:) }

  let!(:activated_card) { create(:card, status: 'activated', product: products.first, user: client) }
  let!(:canceled_card) { create(:card, status: 'canceled', product: products.first, user: client) }

  describe 'GET /reports/brand' do
    it 'returns the brand and its products' do
      get '/reports/brand_report', params: { report: { brand_id: brand.id } }, headers: headers_admin

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response['brand']['name']).to eq('Test brand')
      expect(json_response['products'].size).to eq(3)
      expect(json_response['products'][0]['name']).to eq('Test product')
    end

    context 'when the brand does not exists' do
      it 'returns status code 404' do
        get '/reports/brand_report', params: { report: { brand_id: brand.id + 9 } }, headers: headers_admin

        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET /reports/client' do
    before { create(:client_product, user: client, product: products.first) }

    it 'returns the client details and their products' do
      get '/reports/client_report', params: { report: { client_id: client.id } }, headers: headers_admin

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response['client']['email']).to eq('client@example.com')
      expect(json_response['client']['role']).to eq('client')
      expect(json_response['client']['payout_rate']).to eq('0.0')
      expect(json_response['products'].size).to eq(1)
    end

    context 'when the client does not exists' do
      it 'returns status code 404' do
        get '/reports/client_report', params: { report: { client_id: client.id + 9 } }, headers: headers_admin

        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET /reports/client_transactions' do
    it 'returns activated and canceled transactions details' do
      get '/reports/client_transactions_report', params: { report: { client_id: client.id } }, headers: headers_client

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)

      expect(json_response['activated_transactions'].size).to eq(1)
      expect(json_response['activated_transactions'][0]['id']).to eq(activated_card.id)
      expect(json_response['activated_transactions'][0]['details']).to eq(
        'Product: Test product, Price: 20.00, Brand: Test brand'
      )
      expect(json_response['activated_transactions'][0]['created_at']).to eq(activated_card.created_at.as_json)

      expect(json_response['canceled_transactions'].size).to eq(1)
      expect(json_response['canceled_transactions'][0]['id']).to eq(canceled_card.id)
      expect(json_response['canceled_transactions'][0]['details']).to eq(
        'Product: Test product, Price: 20.00, Brand: Test brand'
      )
      expect(json_response['canceled_transactions'][0]['created_at']).to eq(canceled_card.created_at.as_json)
    end
  end
end
