# frozen_string_literal: true

# spec/services/action_logger_spec.rb
require 'rails_helper'

RSpec.describe ActionLogger, type: :service do
  describe '.log_action' do
    let(:user) { create(:user, :admin) }
    let(:brand) { create(:brand) }

    it 'creates a log entry with correct attributes' do
      expect do
        ActionLogger.log_action(user, 'create', brand)
      end.to change { Log.count }.by(1)

      log = Log.last
      expect(log.user).to eq(user)
      expect(log.action).to eq('create')
      expect(log.record_type).to eq('Brand')
      expect(log.record_id).to eq(brand.id)
      expect(log.details).to eq(brand.attributes.to_json)
    end

    it 'raises an error when mandatory attributes are missing' do
      expect do
        ActionLogger.log_action(nil, 'create', brand)
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        ActionLogger.log_action(user, nil, brand)
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        ActionLogger.log_action(user, 'create', nil)
      end.to raise_error(NoMethodError)
    end
  end
end
