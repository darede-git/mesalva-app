# frozen_string_literal: true

class PlatformUnitiesController < ApplicationController
  before_action :authenticate_permission
  before_action :set_platform_unity, only: %i[show update destroy]

  def index
    @platform_unities = PlatformUnity.root_only(params[:root_only])
                                     .by_parent_id(params[:parent_id])
                                     .by_platform_id(platform_id)
    render json: serialize(@platform_unities), status: :ok
  end

  def create
    @platform_unity = PlatformUnity.new(platform_unity_params.merge(platform_id: platform_id))
    if @platform_unity.save
      render json: serialize(@platform_unity), status: :created
    else
      render_unprocessable_entity(@platform_unity.errors)
    end
  end

  def update
    if @platform_unity.update(platform_unity_params)
      render json: serialize(@platform_unity), status: :ok
    else
      render_unprocessable_entity(@platform_unity.errors.messages)
    end
  end

  def show
    if @platform_unity
      render json: serialize(@platform_unity, v: 3), status: :ok
    else
      render_not_found
    end
  end

  def destroy
    render_unprocessable_entity(@platform_unity.errors.messages) unless \
      @platform_unity.destroy
    render_no_content
  end

  private

  def platform_id
    return Platform.find_by_slug(params[:platform_slug]).id if params[:platform_slug]

    current_platform.id
  end

  def set_platform_unity
    @platform_unity = PlatformUnity.find(params[:id])
  end

  def platform_unities
    PlatformUnity.where(platform_id: platform_id)
  end

  def platform_unity_params
    params.permit(:name, :slug, :uf, :city, :parent_id, :category)
  end
end
