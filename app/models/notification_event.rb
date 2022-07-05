# frozen_string_literal: true

class NotificationEvent < ActiveRecord::Base
  belongs_to :notification

  validates :notification_id, presence: true
  validates_inclusion_of :read, in: [true, false]
end
