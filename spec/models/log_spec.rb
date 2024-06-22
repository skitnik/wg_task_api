# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Log, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:action) }
    it { should validate_presence_of(:record_type) }
    it { should validate_presence_of(:record_id) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end
end
