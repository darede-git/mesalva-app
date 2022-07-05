# frozen_string_literal: true

class RolesController < ApplicationController
  before_action :authenticate_permission
  before_action :set_role, only: %i[show update destroy]

  def index
    roles = Role.page(page_param)
    render json: serialize(roles, v: 3), status: :ok
  end

  def show
    if @role
      render json: serialize(@role, v: 3), status: :ok
    else
      render_not_found
    end
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      render json: serialize(@role, v: 3), status: :created
    else
      render_unprocessable_entity(@role.errors)
    end
  end

  def update
    if @role.update(role_params)
      render json: serialize(@role, v: 3), status: :ok
    else
      render_unprocessable_entity(@role.errors.messages)
    end
  end

  def destroy
    if @role.destroy
      render_no_content
    else
      render_unprocessable_entity(@role.errors.messages)
    end
  end

  private

  def set_role
    @role = Role.find_by_slug(params[:slug])
  end

  def role_params
    params.permit(:name, :slug, :description, :role_type)
  end
end
