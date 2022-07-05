# frozen_string_literal: true

class Subscription < ActiveRecord::Base
  include TokenHelper
  before_validation :generate_token, on: :create

  has_many :orders
  belongs_to :user
  has_one :pagarme_subscription

  validates :user, presence: true
  validates :token, presence: true, uniqueness: true

  accepts_nested_attributes_for :pagarme_subscription

  def renew(new_payment, status, next_recurrence_date)
    case status
    when 'paid'
      payment_to_captured(new_payment, next_recurrence_date)
    when 'pending_payment', 'unpaid'
      new_payment.state_machine.transition_to!(:failed)
    end
    update(status: status, active: status_active?(status))
  end

  def last_order
    orders.order(:created_at).last
  end

  def payment_to_captured(payment, next_recurrence_date)
    payment.order.update(expires_at: next_recurrence_date)
    payment.state_machine.transition_to!(:captured) if payment.card?
  end

  def pagarme?
    orders.collect(&:pagarme?).any?
  end

  def iugu?
    orders.collect(&:iugu?).any?
  end

  private

  def status_active?(status)
    %w[paid pending_payment].include?(status)
  end
end
