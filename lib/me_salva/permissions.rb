# frozen_string_literal: true

module MeSalva
  class Permissions
    def self.create_and_grant(context_action, role_name = 'all')
      context = context_action.split('/').first
      action = context_action.split('/').last
      permission = Permission.find_or_create(context: context, action: action)
      role = Role.find_or_create(slug: role_name)
      PermissionRole.find_or_create(permission: permission, role: role)
    end
  end
end
