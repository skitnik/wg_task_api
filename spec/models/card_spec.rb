# frozen_string_literal: true

require 'rails_helper'

# spec/models/card_spec.rb

RSpec.describe Card, type: :model do
  let!(:user) { create(:user, :client) }
  let!(:brand) { create(:brand) }
  let!(:product) { create(:product, brand:) }

  describe 'associations' do
    it { should belong_to(:product) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    subject { create(:card, user:, product:) }

    it { should validate_presence_of(:activation_number) }
    it { should validate_uniqueness_of(:activation_number) }
    it { should validate_presence_of(:pin) }
    it { should validate_uniqueness_of(:pin) }
    it { should validate_inclusion_of(:status).in_array(%w[requested activated canceled]) }
  end

  describe 'scopes' do
    let!(:requested_card) { create(:card, status: 'requested', user:, product:) }
    let!(:activated_card) { create(:card, status: 'activated', user:, product:) }
    let!(:canceled_card) { create(:card, status: 'canceled', user:, product:) }

    describe '.requested' do
      it 'returns requested cards' do
        expect(Card.requested).to include(requested_card)
        expect(Card.requested).not_to include(activated_card, canceled_card)
      end
    end

    describe '.activated' do
      it 'returns activated cards' do
        expect(Card.activated).to include(activated_card)
        expect(Card.activated).not_to include(requested_card, canceled_card)
      end
    end

    describe '.canceled' do
      it 'returns canceled cards' do
        expect(Card.canceled).to include(canceled_card)
        expect(Card.canceled).not_to include(requested_card, activated_card)
      end
    end
  end

  describe 'callbacks' do
    it 'calls generate_activation_number before validation on create' do
      card = build(:card, user:, product:)
      expect(card).to receive(:generate_activation_number)
      card.valid?
    end

    it 'calls generate_pin before validation on create' do
      card = build(:card, user:, product:)
      expect(card).to receive(:generate_pin)
      card.valid?
    end
  end
end
