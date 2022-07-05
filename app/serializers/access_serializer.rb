# frozen_string_literal: true

class AccessSerializer < ActiveModel::Serializer
  belongs_to :order, foreign_key: :token
  belongs_to :package

  attributes :id,
             :user_uid,
             :starts_at,
             :expires_at,
             :remaining_days,
             :active,
             :updated_at,
             :subscription_active,
             :gift,
             :created_by,
             :in_app_subscription,
             :essay_credits,
             :private_class_credits,
             :unlimited_essay_credits

  def unlimited_essay_credits
    object.package.unlimited_essay_credits
  end

  def user_uid
    object.user.uid
  end

  def subscription_active
    return nil unless subscription?

    object.order_subscription_status
  end

  def expires_at
    return object.expires_at unless object.order.try(:subscription?)

    object.expires_at - ::Access::SUBSCRIPTION_ADDITIONAL_TIME
  end

  def in_app_subscription
    object.order.try(:in_app_order?)
  end

  private

  def subscription?
    object.package_subscription? && object.order_subscription.present?
  end
end
