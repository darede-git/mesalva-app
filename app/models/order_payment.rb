# frozen_string_literal: true

class OrderPayment < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries

  module Methods
    CARD      = 'card'
    BANK_SLIP = 'bank_slip'
    PIX = 'pix'
    ALL = [CARD, BANK_SLIP, PIX].freeze
  end

  belongs_to :order
  has_many :order_payment_transitions,
           class_name: 'OrderPaymentTransition', autosave: false
  has_one :pagarme_transaction
  has_one :play_store_transaction
  has_one :app_store_transaction

  validates :payment_method, inclusion: { in: Methods::ALL }
  validates :installments, numericality: { greater_than: 0 }
  validate :bank_slip_in_installments

  accepts_nested_attributes_for :pagarme_transaction,
                                :play_store_transaction,
                                :app_store_transaction

  scope :by_transaction_id, lambda { |transaction_id|
    joins(:pagarme_transaction)
      .where(transaction_id: transaction_id)
  }

  def card?
    payment_method == Methods::CARD
  end

  def bank_slip?
    payment_method == Methods::BANK_SLIP
  end

  def pix?
    payment_method == Methods::PIX
  end

  def state_machine
    @state_machine ||= OrderPaymentState
                       .new(self, transition_class: OrderPaymentTransition)
  end

  def status
    state_machine.current_state
  end

  def pagarme_status
    return 'refused' if status == 'failed'

    return 'paid' if status == 'captured'

    status
  end

  def transaction_id
    pagarme_transaction_id || play_store_transaction_id ||
      app_store_transaction_id
  end

  private

  def bank_slip_in_installments
    return unless (pix? || bank_slip?) && installments.to_i > 1

    errors.add(:installments, :bank_slip_in_installments)
  end

  def self.transition_class
    OrderPaymentTransition
  end

  def pagarme_transaction_id
    pagarme_transaction.try(:transaction_id)
  end

  def play_store_transaction_id
    play_store_transaction.try(:transaction_id)
  end

  def app_store_transaction_id
    app_store_transaction.try(:transaction_id)
  end

  private_class_method :transition_class
end
