# frozen_string_literal: true

class V2::NotificationEventSerializer
  include FastJsonapi::ObjectSerializer
  attribute :read
end
