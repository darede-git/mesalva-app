# frozen_string_literal: true

module PermissionHelper
  def grant_test_permission(action, granted_user = nil)
    context = controller.class.controller_path
    grant_context_permission(context, action, granted_user)
  end

  def grant_context_permission(context, action, granted_user = nil)
    granted_user = user if granted_user.nil?
    role = Role.create(name: 'Test Role', slug: 'test-role')
    permission = Permission.create(context: context, action: action)
    PermissionRole.create(role_id: role.id, permission_id: permission.id)
    UserRole.create(role_id: role.id, user_id: granted_user.id)
    { role: role, permission: permission }
  end
end
