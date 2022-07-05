# frozen_string_literal: true

class OrderTransition < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordTransition

  belongs_to :order, inverse_of: :order_transitions

  after_destroy :update_most_recent, if: :most_recent?

  scope :not_found, lambda {
    where(to_state: 'not_found')
  }

  private

  def update_most_recent
    last_transition = order.order_transitions.order(:sort_key).last
    return unless last_transition.present?

    last_transition.update_column(:most_recent, true)
  end
end
