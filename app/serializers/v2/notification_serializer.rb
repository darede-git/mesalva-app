# frozen_string_literal: true

class V2::NotificationSerializer
  include FastJsonapi::ObjectSerializer
  has_many :notification_events, serializer: ::V2::NotificationEventSerializer
  attribute :notification_type
end
