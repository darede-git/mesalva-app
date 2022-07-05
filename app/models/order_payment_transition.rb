# frozen_string_literal: true

class OrderPaymentTransition < ActiveRecord::Base
  belongs_to :order_payment, inverse_of: :order_payment_transitions

  after_destroy :update_most_recent, if: :most_recent?

  private

  def update_most_recent
    last_transition = order_payment.order_payment_transitions
                                   .order(:sort_key).last
    return unless last_transition.present?

    last_transition.update_column(:most_recent, true)
  end
end
