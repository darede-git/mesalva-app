# frozen_string_literal: true

class CrmEvent < ActiveRecord::Base
  has_one :utm, as: :referenceable
  accepts_nested_attributes_for :utm,
                                reject_if: proc { |attributes|
                                  attributes['utm_source'].blank?
                                }

  validates :event_name, presence: true, allow_blank: false

  validates :user_id,
            :user_email,
            :user_premium,
            :user_name,
            :user_objective,
            :user_objective_id,
            :education_segment,
            :order_price,
            :order_payment_type,
            :order_id,
            :location,
            :user_agent,
            :client,
            :device,
            presence: true, allow_blank: true
end
