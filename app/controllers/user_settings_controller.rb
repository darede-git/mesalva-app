# frozen_string_literal: true

class UserSettingsController < ApplicationController
  before_action :authenticate_permission
  before_action :set_user
  before_action :set_user_setting, only: %i[show update destroy]

  def index
    user_settings = UserSetting.where(user: @user).page(page_param)
    render json: serialize(user_settings), status: :ok
  end

  def show
    if @user_setting
      render json: serialize(@user_setting), status: :ok
    else
      render_not_found
    end
  end

  def update
    @user_setting = UserSetting.find_or_create(user_settings_show_params)
    if @user_setting.update(value: params[:value])
      render json: serialize(@user_setting), status: :ok
    else
      render_unprocessable_entity(@user_setting.errors.messages)
    end
  end

  def destroy
    return render_not_found if @user_setting.nil?

    if @user_setting.destroy
      render_no_content
    else
      render_unprocessable_entity(@user_setting.errors)
    end
  end

  private

  def set_user_setting
    @user_setting = UserSetting.where(user_settings_show_params).first
  end

  def user_settings_show_params
    params.permit(:key).merge(user: @user)
  end

  def set_user
    return render_unprocessable_entity('Usuário não informado') if params[:user_uid].nil?

    @user = User.find_by_uid(params[:user_uid])

    return render_not_found('Usuário não encontrado') if @user.nil?
  end
end
