# frozen_string_literal: true

class Platform::User::AccessesController < ApplicationController
  before_action :authenticate_permission

  def index
    render json: serialize(accesses, v:3, serializer: 'PlatformAccess')
  end

  private

  def accesses
    Access.with_package
      .by_user_active_in_range(user_by_email)
      .by_platform(platform)
  end

  def user_by_email
    @user_by_email ||= User.find_by_email(params[:user_email])
  end

  def platform
    @platform ||= Platform.find_by_slug(params[:platform_slug]) if params[:platform_slug].present?

    @platform ||= current_platform
  end
end
