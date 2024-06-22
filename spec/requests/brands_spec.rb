# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Brands', type: :request do
  let(:user) { create(:user, :admin) }
  let(:headers) { { 'Authorization' => JsonWebToken.encode(user_id: user.id) } }
  let!(:brand) { create(:brand) }
  let(:valid_attributes) { { name: 'New Brand', description: 'A new brand', state: 'active' } }
  let(:non_existing_brand_id) { brand.id + 9 }

  describe 'POST /brands' do
    context 'when the request is valid' do
      it 'creates a brand' do
        expect(ActionLogger).to receive(:log_action)

        post('/brands', params: { brand: valid_attributes }, headers:)

        expect(response).to have_http_status(201)
        expect(json['name']).to eq('New Brand')
      end
    end

    context 'when the request is invalid' do
      before { post '/brands', params: { brand: { name: nil } }, headers: }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['name']).to include("can't be blank")
      end
    end

    context 'when the user is not admin' do
      before do
        user.update(role: :client)
        post '/brands', params: { brand: valid_attributes }, headers:
      end

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'PUT /brands/:id' do
    context 'when the record exists' do
      it 'updates the record' do
        expect(ActionLogger).to receive(:log_action)

        put("/brands/#{brand.id}", params: { brand: valid_attributes }, headers:)
        expect(response).to have_http_status(200)
        expect(json['name']).to eq('New Brand')
      end
    end

    context 'when the record does not exists' do
      it 'returns status code 404' do
        put("/brands/#{non_existing_brand_id}", params: { brand: valid_attributes }, headers:)

        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'PATCH /brands/:id/change_state' do
    context 'when the request is valid' do
      it 'changes the state of the brand' do
        expect(ActionLogger).to receive(:log_action)

        patch("/brands/#{brand.id}/change_state", params: { brand: { state: 'active' } }, headers:)

        expect(response).to have_http_status(200)
        expect(json['state']).to eq('active')
      end
    end

    context 'when the record does not exists' do
      it 'returns status code 404' do
        patch("/brands/#{non_existing_brand_id}/change_state", params: { brand: { state: 'active' } }, headers:)

        expect(response).to have_http_status(404)
      end
    end
  end
end
