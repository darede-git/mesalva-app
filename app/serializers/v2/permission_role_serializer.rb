# frozen_string_literal: true

class V2::PermissionRoleSerializer
    include FastJsonapi::ObjectSerializer
  
    attributes :role_id, :permission_id

    attribute :permitted do |object|
      hash = JSON.parse(object.to_json)
      hash.key?("role_id") && object.role_id.present?
    end
  end
