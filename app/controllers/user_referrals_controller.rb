# frozen_string_literal: true

class UserReferralsController < ApplicationController
  before_action -> { authenticate(%w[user]) }
  before_action :set_user_referral

  def index
    count_referrals if user_clear_to_check_referrals
    if @user_referral.being_processed
      render json: serialize(@user_referral), status: :partial_content
    else
      render json: serialize(@user_referral), status: :ok
    end
  end

  private

  def user_clear_to_check_referrals
    return true if @user_referral.last_checked.nil?

    cached_interval < Time.now
  end

  def cached_interval
    @user_referral.last_checked + ENV['REFERRAL_INTERVAL_IN_HOURS'].to_i.hours
  end

  def count_referrals
    @user_referral.update(last_checked: Time.now, being_processed: true)
    @user_referral.save
    UserReferralCounterWorker.perform_async(@user_referral.user.token)
  end

  def set_user_referral
    @user_referral = UserReferral.find_by_user_id(current_user.id)
    create_referral if @user_referral.nil?
  end

  def create_referral
    @user_referral = UserReferral.create(user_id: current_user.id)

    render json: serialize(@user_referral), status: :created
  end
end
