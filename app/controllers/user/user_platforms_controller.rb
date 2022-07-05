# frozen_string_literal: true

class User::UserPlatformsController < ApplicationController
  before_action -> { authenticate_permalink_access(%w[user]) }, only: :index
  before_action -> { authenticate_permalink_access(%w[user teacher admin]) }, only: :me

  def index
    @platforms = Platform.by_user(current_user.id)
    if @platforms
      render json: serialize(@platforms), status: :ok
    else
      render_not_found
    end
  end

  def me
    return render_not_found if current_platform.nil?

    @user_platform = UserPlatform.where(platform_id: current_platform.id, user_id: current_user.id).take
    render json: @user_platform, status: :ok
  end
end
