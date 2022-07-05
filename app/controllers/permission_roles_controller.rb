# frozen_string_literal: true

class PermissionRolesController < ApplicationController
  before_action :authenticate_permission

  def grant_permission
    @role = Role.find_by_slug(params[:role_slug])
    permission_role = PermissionRole.find_or_create(permission_id: params[:permission_id], role_id: @role.id)
    render_results(permission_role)
  end

  def remove_permission
    @role = Role.find_by_slug(params[:role_slug])
    deleted = PermissionRole.where(permission_id: params[:permission_id], role_id: @role.id).delete_all
    render_results({
                     deleted: deleted
                   })
  end
end
