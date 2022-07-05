# frozen_string_literal: true

class V3::PermissionSerializer < V3::BaseSerializer
  attributes :id, :context, :action, :permission_type, :description, :permitted

  def permitted(object)
    hash = JSON.parse(object.to_json)
    hash.key?("role_id") && object.role_id.present?
  end
end
