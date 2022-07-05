# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class Order < ActiveRecord::Base
  include Statesman::Adapters::ActiveRecordQueries
  include TokenHelper
  include TextSearchHelper
  include AlgoliaSearch
  module Brokers
    PAGARME = 'pagarme'
    IUGU    = 'iugu'
    PLAY_STORE = 'play_store'
    APP_STORE = 'app_store'
    KOIN = 'koin'
    ASAAS = 'asaas'
    SCHOLARSHIP = 'scholarship'
    ALL = [PAGARME, IUGU, PLAY_STORE, APP_STORE, SCHOLARSHIP, KOIN, ASAAS].freeze
  end

  before_create :set_default_attributes
  before_validation :generate_token, on: :create

  STATUS = { pending: 1, paid: 2,     canceled: 3, expired: 4,
             invalid: 5, refunded: 6, not_found: 7, pre_approved: 8 }.freeze

  PURCHASE_TYPE = { new: 1, renew: 2, repurchase: 3 }.freeze
  ORDER_EVENT = { generate: 1, regenerate: 2, remission: 3 }.freeze

  has_many :payments, class_name: 'OrderPayment'
  has_many :order_transitions, autosave: false
  has_many :accesses

  belongs_to :package
  belongs_to :user
  belongs_to :subscription
  belongs_to :discount

  has_one :cancellation_quiz

  has_one :address, as: :addressable
  accepts_nested_attributes_for :address, :payments

  has_one :utm, as: :referenceable
  accepts_nested_attributes_for :utm,
                                reject_if: proc { |attributes|
                                  attributes['utm_source'].blank?
                                }

  validates  :user, :package, :broker, :currency, presence: true
  validates  :checkout_method,
             inclusion: { in: %w[bank_slip credit_card pix
                                 play_store app_store] },
             if: ->(order) { order.payments.blank? }
  validates  :broker, inclusion: { in: Brokers::ALL }
  validates  :token, presence: true, uniqueness: true
  validate   :in_app_purchase_has_expires_at, if: :in_app_purchase?
  validate   :ensure_one_bank_slip_per_order
  validate   :payments_equal_package_price
  validate   :installments_in_valid_range
  validate   :valid_play_store_invoice, if: :play_store?

  mount_base64_uploader :payment_proof, OrderImageUploader
  scope :pending, -> { where(status: STATUS[:pending]) }
  scope :by_iugu, -> { where(broker: Brokers::IUGU) }
  scope :by_play_store, -> { where(broker: Brokers::PLAY_STORE) }

  scope :expired_pending, lambda {
    where("created_at <  ?", expire_date).pending
  }

  scope :pending_order_subscriptions, lambda {
                                        joins(:package).where('packages.subscription=true').pending
                                      }

  scope :pending_order_one_shots, lambda {
    joins(:package).where('packages.subscription = false').pending
  }

  scope :pending_order_one_shots_credit_card, lambda {
    pending_order_one_shots.where("checkout_method = 'credit_card'")
  }

  scope :pending_order_one_shots_bank_slip, lambda {
    pending_order_one_shots.where("checkout_method = 'bank_slip'")
  }

  scope :expired_subscription_orders, lambda {
    joins(:subscription).expired_orders
  }

  scope :expired_orders, lambda {
    where(status: STATUS[:paid]).where('expires_at < ?', Time.now)
                                .where(processed: false)
  }

  scope :by_user, lambda { |user|
    where(user: user).order(created_at: :desc)
  }

  scope :paid, lambda {
    where(status: STATUS[:paid])
  }

  scope :buzzlead_expired, lambda {
    joins(:utm)
      .where(status: STATUS[:paid])
      .where('orders.updated_at < ?', Time.now - 7.days)
      .where(buzzlead_processed: false)
      .where(utms: { utm_source: 'buzzlead' })
  }

  def complementary_packages
    complementary_package_ids.map { |id| Package.find(id) }
  end

  def complementary_packages=(packages)
    self.complementary_package_ids = packages.pluck(:id)
  end

  def report_csv
    attributes = %i[order_token user_uid package_id order_payment_id
                    payment_method pagarme_transaction_id amount paid_amount]

    report = order_report
    CSV.generate(headers: true) do |csv|
      csv << attributes
      csv << attributes.map { |attr| report[attr] }
    end
  end

  def self.expire_date
    Time.now - 8.days
  end

  def in_app_purchase?
    %w[play_store app_store].include? broker
  end

  def set_default_attributes
    self.status ||= STATUS[:pending]
    self.purchase_type = set_purchase_type
    self.order_event ||= ORDER_EVENT[:generate]
  end

  def state_machine
    @state_machine ||= OrderState.new(self, transition_class: OrderTransition)
  end

  def save_status_with_string(key)
    self.status = STATUS[key.to_sym]
    save!
  end

  def self.convert_status_key(key)
    STATUS[key]
  end

  def status_humanize
    STATUS.key(status)
  end

  def self.convert_purchase_type_key(key)
    PURCHASE_TYPE[key]
  end

  def self.convert_order_event_key(key)
    ORDER_EVENT[key]
  end

  def subscription_broker_id
    subscription&.broker_id
  end

  def subscription?
    package.subscription
  end

  def credit_card?
    checkout_method == 'credit_card'
  end

  def bank_slip?
    checkout_method == 'bank_slip'
  end

  def pix?
    checkout_method == 'pix'
  end

  def bank_slip_pending?
    status == Order.convert_status_key(:pending) && bank_slip?
  end

  def pdf
    return payments.first.try(:pdf) if pagarme? && bank_slip?

    broker_data['pdf'] if broker_data.present? && broker_data.key?('pdf')
  end

  def barcode
    return unless pagarme? && bank_slip?

    payments.find_by_payment_method('bank_slip').try(:barcode)
  end

  def qr_code
    return unless pagarme? && pix?

    payments.find_by_payment_method('pix').try(:barcode)
  end

  def subscription_active
    subscription.active
  end

  def package_name
    package.name
  end

  def destroy_not_found_transitions
    find_not_found_transitions.destroy_all
  end

  def transition_to_paid
    state_machine.transition_to(:paid)
  end

  def iugu?
    broker == Brokers::IUGU
  end

  def pagarme?
    broker == Brokers::PAGARME
  end

  def play_store?
    broker == Brokers::PLAY_STORE
  end

  def app_store?
    broker == Brokers::APP_STORE
  end

  def price
    Price.by_package_and_price_type(package.id, price_method)
  end

  def price_method
    return broker if in_app_order?

    if payments.blank?
      checkout_method
    elsif payments.all?(&:bank_slip?)
      'bank_slip'
    elsif payments.all?(&:pix?)
      'pix'
    else
      'credit_card'
    end
  end

  def upgrade_plan?
    return false if last_valid_order.nil?

    price_duration_proportion(package.duration, price_paid) >
      price_duration_proportion(last_valid_order.package.duration, last_valid_order.price_paid)
  end

  def price_duration_proportion(duration, price)
    price.to_f / duration.to_i
  end

  def last_valid_order
    Order.where(user_id: user_id, status: STATUS[:paid]).last(2).first
  end

  def checkout_method
    return broker if in_app_order?
    return super unless payments.present?
    return 'multiple' if multiple_payments?
    return 'credit_card' if payments.first.payment_method =~ /card/

    payments.first.payment_method
  end

  def multiple_payments?
    payments.size > 1
  end

  def in_app_order?
    play_store? || app_store?
  end

  def billing_data
    return if iugu?

    payments.map do |payment|
      { metadata: payment.metadata,
        amount_in_cents: payment.amount_in_cents,
        payment_method: payment.payment_method,
        installments: payment.installments }
    end
  end

  def paid?
    status == STATUS[:paid]
  end

  def refunded?
    status == STATUS[:refunded]
  end

  algoliasearch index_name: name.pluralize, disable_indexing: Rails.env.test? do
    attributesForFaceting %w[uid]
    attribute :email,
              :broker,
              :currency,
              :cpf
    attribute :broker_invoice do
      broker_id
    end
    attribute :id do
      token
    end
    attribute :uid do
      user.uid
    end
    attribute :user_name do
      user.name
    end
    attribute :user_email do
      user.email
    end
    attribute :package_name do
      package.name
    end
    attribute :package_info do
      package.info.try(:first)
    end
    attribute :price_paid do
      price_paid.to_f
    end
    attribute :status do
      status_humanize.to_s
    end
    attribute :checkout_method do
      checkout_method
    end
    attribute :billing_data do
      billing_data
    end
    attribute :created_at do
      created_at.strftime('%a, %e %b %Y %H:%M:%S')
    end
    attribute :refunded_at do
      updated_at.strftime('%a, %e %b %Y %H:%M:%S') if status == 6
    end
    attribute :installments do
      all_installments
    end
  end

  def broker_id
    return broker_invoice if iugu?

    payments.collect(&:transaction_id).join ';'
  end

  def all_paid?
    payments.all.select(&:card?).all? do |card|
      card.state_machine.current_state == 'captured'
    end
  end

  def collectable?
    payments.all.select(&:card?).all? do |card|
      %w[authorized capturing captured]
        .include?(card.state_machine.current_state)
    end
  end

  def all_bank_slips_paid?
    payments.all.select(&:bank_slip?).all? do |card|
      card.state_machine.current_state == 'paid'
    end
  end

  def play_store_transaction
    payments.take.try(:play_store_transaction)
  end

  def refundable?
    return false unless paid?
    return true if pagarme? || iugu?
    return refundable_play_store_order? if play_store?

    false
  end

  def all_installments
    return payments.collect(&:installments).join ';' if payments.present?

    installments
  end

  def buzzlead_indication?
    utm&.utm_source == 'buzzlead'
  end

  private

  # rubocop:disable Metrics/AbcSize
  def order_report
    return teste_order_response if Rails.env.test?

    order_payment = payments.first
    order_transaction = order_payment.pagarme_transaction

    pagarme_transaction = PagarMe::Transaction.find_by_id(order_transaction.transaction_id)

    paid_amount = pagarme_transaction.events.map { |event| event.payload.paid_amount }.compact

    { order_token: token, user_uid: user.uid, package_id: package.id,
      order_payment_id: order_payment.id, payment_method: order_payment.payment_method,
      pagarme_transaction_id: pagarme_transaction.id,
      paid_amount: paid_amount, amount: order_payment.amount_in_cents }
  end
  # rubocop:enable Metrics/AbcSize

  def teste_order_response
    {
      order_token: "test", user_uid: "test", package_id: "3145", order_payment_id: "2",
      payment_method: "card", pagarme_transaction_id: "1645721", paid_amount: "1999", amount: "2000"
    }
  end

  def set_purchase_type
    return PURCHASE_TYPE[:renew] if subscription && renew?
    return PURCHASE_TYPE[:new] if user.orders.empty?

    PURCHASE_TYPE[:repurchase]
  end

  def renew?
    subscription.orders.count >= 1
  end

  def self.transition_class
    OrderTransition
  end

  private_class_method :transition_class

  def in_app_purchase_has_expires_at
    errors.add(:expires_at) unless expires_at
  end

  def find_not_found_transitions
    order_transitions.not_found
  end

  def ensure_one_bank_slip_per_order
    return unless payments.select(&:bank_slip?).count > 1

    errors.add(:payments, :multiple_bank_slips)
  end

  def payments_equal_package_price
    return if package.nil? || price.nil? || in_app_purchase?

    errors.add(:payments, :invalid_payment_amounts) if invalid_prices_match?
  end

  def invalid_prices_match?
    payments.present? && total_paid_amount != price_with_discount
  end

  def total_paid_amount
    payments.inject(0) { |acc, elem| acc + elem[:amount_in_cents] }
  end

  def price_with_discount
    price_in_cents - discount_in_cents
  end

  def price_in_cents
    DecimalAmount.new(price.value).to_i +
      (ComplementaryPackage.sum_complementary_packages_prices(complementary_package_ids,
                                                              price_method) * 100)
  end

  def installments_in_valid_range
    return true if package && installments.positive? &&
                   installments <= package.max_payments

    errors.add(:installments, :invalid_installments_range)
  end

  def refundable_play_store_order?
    id == play_store_subscription_orders.last.id
  end

  def play_store_subscription_invoice
    broker_invoice.split('..').first
  end

  def play_store_subscription_orders
    user.orders.by_play_store.where('broker_invoice LIKE ?',
                                    "#{play_store_subscription_invoice}%")
        .order(:created_at)
  end

  def valid_play_store_invoice
    return if broker_invoice.nil?

    errors.add(:broker_invoice, 'invalid recurrence representation') \
      unless broker_invoice.start_with?('GPA.')
  end
end
# rubocop:enable Metrics/ClassLength
