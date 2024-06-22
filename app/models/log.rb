# frozen_string_literal: true

class Log < ApplicationRecord
  validates :action, presence: true
  validates :record_type, presence: true
  validates :record_id, presence: true

  belongs_to :user
end
