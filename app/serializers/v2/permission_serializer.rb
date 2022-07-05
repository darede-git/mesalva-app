# frozen_string_literal: true

class V2::PermissionSerializer
    include FastJsonapi::ObjectSerializer
  
    attributes :context, :action, :permission_type, :description

    attribute :permitted do |object|
      hash = JSON.parse(object.to_json)
      hash.key?("role_id") && object.role_id.present?
    end
  end
