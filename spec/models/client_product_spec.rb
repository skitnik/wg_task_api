# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ClientProduct, type: :model do
  let(:brand) { create(:brand) }
  let!(:product) { create(:product, brand:) }
  let(:user) { create(:user, :client) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:product) }
  end

  describe 'validations' do
    it 'validates uniqueness of user_id scoped to product_id' do
      existing_client_product = create(:client_product, user_id: user.id, product_id: product.id)
      new_client_product = build(:client_product, user: existing_client_product.user,
                                                  product: existing_client_product.product)

      expect(new_client_product).not_to be_valid
    end
  end
end
