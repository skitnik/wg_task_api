# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CatalogsController, type: :request do
  let(:client) { create(:user, :client) }
  let(:headers) { { 'Authorization' => JsonWebToken.encode(user_id: client.id) } }
  let(:brand) { create(:brand) }
  let(:inactive_brand) { create(:brand, state: 'inactive') }
  let!(:products) { create_list(:product, 5, brand:) }
  let!(:client_products) do
    products.each do |product|
      create(:client_product, user: client, product:)
    end
  end

  describe 'GET #index' do
    context 'when the request is valid' do
      it 'returns all active products for the client' do
        get('/catalogs', headers:)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(5)
      end

      it 'returns products filtered by brand_id' do
        get('/catalogs', params: { catalog: { brand_id: brand.id } }, headers:)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(5)
      end

      it 'does not return products from inactive brand' do
        product = create(:product, brand: inactive_brand)
        create(:client_product, user: client, product:)

        get('/catalogs', params: { catalog: { brand_id: inactive_brand.id } }, headers:)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(0)
      end

      it 'returns products filtered by product_name' do
        product = create(:product, name: 'Filtered product', brand:)
        create(:client_product, user: client, product:)

        get('/catalogs', params: { catalog: { product_name: 'Filtered product' } }, headers:)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(1)
      end

      it 'paginates the products' do
        get('/catalogs', params: { catalog: { page: 1 } }, headers:)

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to be <= 20
      end
    end

    context 'when the request is invalid' do
      it 'returns a 403 status when the user is not a client' do
        admin = create(:user, :admin)
        headers = { 'Authorization' => JsonWebToken.encode(user_id: admin.id) }

        get('/catalogs', headers:)

        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
