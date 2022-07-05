# frozen_string_literal: true

class User::PermissionsController < ApplicationController
  before_action :authenticate_permission

  def index
    permissions = Permission.by_user_id(user_id).page(page_param)
    render json: serialize(permissions), status: :ok
  end

  def by_context
    permissions = Permission.by_user_id(user_id)
                            .by_context(params[:context]).page(page_param)
    render json: serialize(permissions), status: :ok
  end

  def show
    permission = Permission.by_user_id(user_id)
                           .by_context(params[:context])
                           .by_action(params[:action_name])
                           .first
    return render_not_found unless permission

    render json: serialize(permission), status: :ok
  end

  private

  def user_id
    current_user.id unless current_user.nil?

    current_admin.user.id
  end

  def permission_params
    params.permit(:context)
  end
end
