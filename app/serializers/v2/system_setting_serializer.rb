# frozen_string_literal: true

class V2::SystemSettingSerializer < V3::BaseSerializer
  attributes :key, :value
end
