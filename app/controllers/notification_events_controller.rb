# frozen_string_literal: true

class NotificationEventsController < ApplicationController
  before_action :set_notification_event, only: %i[update destroy]
  before_action -> { authenticate(%w[admin user]) }, only: :create
  before_action -> { authenticate(%w[admin]) }, only: %i[update destroy]

  def create
    @notification_event = NotificationEvent.new(notification_event_params)

    if @notification_event.save
      render json: serialize(@notification_event), status: :created
    else
      render json: @notification_event.errors, status: :unprocessable_entity
    end
  end

  def update
    if @notification_event.update(notification_event_params)
      render json: serialize(@notification_event)
    else
      render json: @notification_event.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @notification_event.destroy
  end

  private

  def set_notification_event
    @notification_event = NotificationEvent.find(params[:id])
  end

  def notification_event_params
    params.permit(:notification_id, :read).merge(user_id: user_id)
  end

  def user_id
    return find_user_by_uid.id if admin_with_user_filter?

    current_user.id
  end

  def admin_with_user_filter?
    params['user_uid'] && admin_signed_in?
  end

  def find_user_by_uid
    User.find_by_uid(params[:user_uid])
  end
end
