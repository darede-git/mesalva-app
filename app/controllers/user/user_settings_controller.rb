# frozen_string_literal: true

class User::UserSettingsController < ApplicationController
  before_action :authenticate_permission

  def index
    user_settings = UserSetting.where(user: current_user).page(page_param)
    render json: serialize(user_settings), status: :ok
  end

  def show
    @user_setting = UserSetting.where(user_setting_show_params).take
    if @user_setting
      render json: serialize(@user_setting), status: :ok
    else
      render_not_found
    end
  end

  def upsert
    @user_setting = UserSetting.find_or_create(user_setting_show_params)
    if @user_setting.update(user_setting_update_params)
      render json: serialize(@user_setting), status: :ok
    else
      render_unprocessable_entity(@user_setting.errors.messages)
    end
  end

  private

  def user_setting_show_params
    params.permit(:key).merge(user: current_user)
  end

  def user_setting_update_params
    params.permit(:key, value: {}).merge(user: current_user)
  end
end
