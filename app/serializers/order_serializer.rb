# frozen_string_literal: true

class OrderSerializer < ActiveModel::Serializer
  belongs_to :package
  has_one :address

  attributes :status, :price_paid, :checkout_method, :payment_methods,
             :subscription_id, :email, :created_at, :discount_in_cents,
             :currency, :payments_errors, :refundable, :payment_proof,
             :bookshop_gifts, :delivery_status, :tracking_code, :bling_id,
             :broker_data

  def id
    object.token
  end

  def status
    object.status_humanize
  end

  def subscription_id
    object.subscription.token if object.subscription_id
  end

  def payment_methods
    object.payments.map do |payment|
      standard_params_for(payment).tap do |result|
        result.merge!(credit_card_params(payment)) if payment.card? && payment.metadata
        result
      end
    end
  end

  def standard_params_for(payment)
    { method: payment.payment_method,
      state: payment.state_machine.current_state,
      amount_in_cents: payment.amount_in_cents }
  end

  def credit_card_params(payment)
    { token: payment.card_token,
      last4: payment.metadata['last4'],
      brand: payment.metadata['brand'] }
  end

  def payments_errors
    object.payments.pluck(:error_message)
  end

  def refundable
    object.refundable?
  end

  def bookshop_gifts
    @bookshop_gifts = []
    bookshop_gift_main_package
    bookshop_gift_complementary_packages
    @bookshop_gifts
  end

  def bookshop_gift_main_package
    object.package.bookshop_gift_packages.each do |bookshop_gift_package|
      bookshop_gift_package.bookshop_gifts.each do |bookshop_gift|
        @bookshop_gifts << bookshop_gift_params(bookshop_gift)
      end
    end
  end

  def bookshop_gift_complementary_packages
    object.complementary_packages.each do |package|
      package.bookshop_gift_packages.each do |bookshop_gift_package|
        bookshop_gift_package.bookshop_gifts.each do |bookshop_gift|
          @bookshop_gifts << bookshop_gift_params(bookshop_gift)
        end
      end
    end
  end

  def bookshop_gift_params(bookshop_gift)
    { coupon: bookshop_gift.coupon, coupon_available: bookshop_gift.coupon_available }
  end
end
