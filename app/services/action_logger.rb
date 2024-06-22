# frozen_string_literal: true

class ActionLogger
  def self.log_action(user, action, record)
    Log.create!(
      user:,
      action:,
      record_type: record.class.name,
      record_id: record.id,
      details: record.attributes.to_json
    )
  end
end
