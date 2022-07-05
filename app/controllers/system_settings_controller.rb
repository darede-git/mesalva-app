# frozen_string_literal: true

class SystemSettingsController < ApplicationController
  before_action :authenticate_permission
  before_action :set_system_setting, only: %i[show update destroy]

  def index
    system_settings = SystemSetting.page(page_param)
    render json: serialize(system_settings), status: :ok
  end

  def show
    if @system_setting
      render json: serialize(@system_setting), status: :ok
    else
      render_not_found
    end
  end

  def create
    @system_setting = SystemSetting.new(system_setting_params)
    if @system_setting.save
      render json: serialize(@system_setting), status: :created
    else
      render_unprocessable_entity(@system_setting.errors)
    end
  end

  def update
    if @system_setting.update(system_setting_params)
      render json: serialize(@system_setting), status: :ok
    else
      render_unprocessable_entity(@system_setting.errors)
    end
  end

  def destroy
    if @system_setting.destroy
      render_no_content
    else
      render_unprocessable_entity(@system_setting.errors)
    end
  end

  private

  def set_system_setting
    @system_setting = SystemSetting.find_by_key(system_setting_params[:key])
  end

  def system_setting_params
    params.permit(:id, :key, value: {})
  end
end
