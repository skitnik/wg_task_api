# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Products', type: :request do
  let(:admin) { create(:user, :admin) }
  let(:client) { create(:user, :client) }
  let(:headers) { { 'Authorization' => JsonWebToken.encode(user_id: admin.id) } }
  let!(:brand) { create(:brand) }
  let!(:product) { create(:product, brand:) }
  let!(:product2) { create(:product, brand:) }
  let(:valid_attributes) { { name: 'New Product', description: 'A new product', price: 19.99, brand_id: brand.id } }
  let(:non_existing_product_id) { product.id + 9 }

  describe 'POST /products' do
    context 'when the request is valid' do
      it 'creates a product' do
        expect(ActionLogger).to receive(:log_action)

        post('/products', params: { product: valid_attributes.merge(brand:) }, headers:)

        expect(response).to have_http_status(201)
        expect(json['name']).to eq('New Product')
      end
    end

    context 'when the request is invalid' do
      before { post '/products', params: { product: { name: nil } }, headers: }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(json['name']).to include("can't be blank")
      end
    end
  end

  describe 'PUT /products/:id' do
    context 'when the record exists' do
      it 'updates the record' do
        expect(ActionLogger).to receive(:log_action)

        put("/products/#{product.id}", params: { product: valid_attributes }, headers:)

        expect(response).to have_http_status(200)
        expect(json['name']).to eq('New Product')
      end
    end

    context 'when the record does not exists' do
      it 'returns status code 404' do
        put("/products/#{non_existing_product_id}", params: { product: valid_attributes }, headers:)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'DELETE /products/:id' do
    it 'deletes the record' do
      expect(ActionLogger).to receive(:log_action)

      delete("/products/#{product.id}", headers:)

      expect(response).to have_http_status(204)
    end

    context 'when the record does not exists' do
      it 'returns status code 404' do
        delete("/products/#{non_existing_product_id}", headers:)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'PATCH /products/:id/change_state' do
    context 'when the request is valid' do
      it 'changes the state of the brand' do
        expect(ActionLogger).to receive(:log_action)

        patch("/products/#{product.id}/change_state", params: { product: { state: 'active' } },
                                                      headers:)

        expect(response).to have_http_status(200)
        expect(json['state']).to eq('active')
      end
    end

    context 'when the record does not exists' do
      it 'returns status code 404' do
        patch("/products/#{non_existing_product_id}/change_state",
              params: { product: { state: 'active' } }, headers:)
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /products/assign_to_client' do
    context 'when the request is valid' do
      let(:valid_attributes) { { user_id: client.id, product_ids: [product.id, product2.id] } }

      context 'when the products are not assigned' do
        it 'assigns the products to the client' do
          expect(ActionLogger).to receive(:log_action).twice

          post('/products/assign_to_client', params: { products: valid_attributes }, headers:)

          expect(response).to have_http_status(201)
          expect(json).to eq({ 'message' => 'Products assigned.', 'unassigned_products' => [] })
          expect(client.products.count).to eq(2)
        end
      end

      context 'when one product is already assigned' do
        before { create(:client_product, user_id: client.id, product_id: product.id) }

        it 'assigns only the second product to the client' do
          expect(ActionLogger).to receive(:log_action).once

          post('/products/assign_to_client', params: { products: valid_attributes }, headers:)

          expect(response).to have_http_status(201)
          expect(json).to eq({
                               'message' => 'Products assigned.',
                               'unassigned_products' => [{ 'base' => ["Product #{product.id} already assigned"] }]
                             })
          expect(client.products.count).to eq(2)
        end
      end
    end
  end
end
