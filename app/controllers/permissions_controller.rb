# frozen_string_literal: true

class PermissionsController < ApplicationController
  before_action :authenticate_permission
  before_action :set_permission, except: %i[index create]

  def index
    permissions = Permission.ms_filters(permitted_filters).page(page_param)
    render json: serialize(permissions, v: 3), status: :ok
  end

  def create
    @permission = Permission.new(permission_params)
    return render json: serialize(@permission, v: 3), status: :created if @permission.save

    render_unprocessable_entity(@permission.errors)
  end

  def update
    if @permission.update(permission_params)
      return render json: serialize(@permission, v: 3), status: :ok
    end

    render_unprocessable_entity(@permission.errors.messages)
  end

  def show
    return render json: serialize(@permission, v: 3), status: :ok if @permission

    render_not_found
  end

  def destroy
    return render_unprocessable_entity if @permission.permission_roles.present?

    return render_no_content if @permission.destroy

    render_unprocessable_entity(@permission.errors.messages)
  end

  def by_role
    permissions = Permission.left_by_role_slug(params[:role_slug]).page(page_param)
    render json: serialize(permissions, v: 3), status: :ok
  end

  private

  def set_permission
    @permission = Permission.find_or_create(show_params)
  end

  def show_params
    params.permit(:context).merge(action: params[:action_name])
  end

  def permission_params
    params.permit(:context, :description, :permission_type).merge(action: params[:action_name])
  end

  def permitted_filters
    params.permit(:context, :like_context, :like_action, :permission_type)
          .merge(action: params[:action_name])
  end
end
