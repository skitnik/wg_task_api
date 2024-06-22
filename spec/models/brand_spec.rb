# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Brand, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:state) }
    it { should validate_inclusion_of(:state).in_array(%w[inactive active]) }
  end

  describe 'associations' do
    it 'has many products' do
      should have_many(:products).dependent(:destroy)
    end
  end
end
