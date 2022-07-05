# frozen_string_literal: true

class V2::UserSettingSerializer < V2::ApplicationSerializer
  attributes :key, :value
end
