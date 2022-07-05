# frozen_string_literal: true

class V2::AccessSerializer < V2::ApplicationSerializer
  belongs_to :order, id_method_name: :order_id
  belongs_to :package

  attributes :starts_at, :remaining_days, :active, :updated_at, :gift,
             :created_by, :essay_credits, :unlimited_essay_credits,
             :private_class_credits

  attribute :user_uid do |object|
    object.user.uid
  end

  attribute :subscription_active do |object|
    if object.package_subscription? && object.order_subscription.present?
      object.order_subscription_status
    end
  end

  attribute :expires_at do |object|
    if object.order.try(:subscription?)
      object.expires_at - ::Access::SUBSCRIPTION_ADDITIONAL_TIME
    else
      object.expires_at
    end
  end

  attribute :in_app_subscription do |object|
    object.order.try(:in_app_order?)
  end

  attribute :unlimited_essay_credits do |object|
    object.package.unlimited_essay_credits
  end
end
