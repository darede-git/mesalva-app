# frozen_string_literal: true

class V2::OrderSerializer < V2::ApplicationSerializer
  set_id :token
  belongs_to :package
  has_one :address

  attributes :price_paid, :checkout_method, :email, :created_at,
             :discount_in_cents, :currency

  attribute :status, &:status_humanize

  attribute :subscription_id do |object|
    object.subscription.token if object.subscription_id
  end
end
