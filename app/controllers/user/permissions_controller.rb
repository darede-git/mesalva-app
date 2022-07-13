# frozen_string_literal: true

class User::PermissionsController < ApplicationController
  before_action :authenticate_permission
  before_action :validate_admin_user_presence

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

  def validate_admin_user_presence
    render_unprocessable_entity(t('errors.messages.admin_has_no_user_equivalent')) if user_id.nil?
  end

  def user_id
    return @user_id unless @user_id.nil?

    @user_id = current_user.id unless current_user.nil?

    @user_id = current_admin.user.id
  end

  def permission_params
    params.permit(:context)
  end
end
