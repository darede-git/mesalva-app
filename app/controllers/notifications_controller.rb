# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[show update destroy]
  before_action -> { authenticate(%w[admin user]) }, only: :index
  before_action -> { authenticate(%w[admin]) }, only: %i[show update destroy]

  def index
    render json: serialize(notifications, include: [:notification_events]), status: :ok
  end

  def show
    if @notification
      render json: serialize(@notification, include: [:notification_events]), status: :ok
    else
      render_not_found
    end
  end

  def destroy
    @notification.destroy
    render_no_content
  end

  private

  def set_notification
    @notification = Notification.find(params[:id])
  end

  def notifications
    return Notification.all_by_user(find_user_by_uid) if admin_with_user_filter

    Notification.by_user(current_user).page(page).per_page(per_page)
  end

  def find_user_by_uid
    @user ||= User.find_by_uid(params['user_uid'])
  end

  def admin_with_user_filter
    params['user_uid'] && admin_signed_in?
  end

  def page
    params[:page] || 1
  end

  def per_page
    params[:per_page] || 3
  end
end
