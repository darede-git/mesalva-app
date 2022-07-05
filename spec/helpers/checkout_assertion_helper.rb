# frozen_string_literal: true

module CheckoutAssertionHelper
  def asserts_one_card_payment(complementary_packages, order, card, discount = 0)
    set_values(complementary_packages, order, 'credit_card', discount, [card])
    asserts_basic
    asserts_payments_creation(order.payments.last, 'card', @total_price_paid, card[:token])
    asserts_payments_metadata_creation(order.payments.last, card)
    asserts_payments_response_one_payment(card, @total_price_paid)
  end

  def asserts_two_cards_payment(complementary_packages, order, cards, discount = 0)
    set_values(complementary_packages, order, 'credit_card', discount, cards)
    asserts_basic
    @order.payments.each_with_index do |payment, i|
      asserts_payments_creation(payment, 'card', @prices_paid[i], @payments_method_info[i][:token])
      asserts_payments_metadata_creation(payment, @payments_method_info[i])
      asserts_payments_response_two_payments(@payments_method_info[i], @prices_paid[i])
    end
  end

  def asserts_bank_slip_payment(complementary_packages, order, bank_slip, discount = 0)
    set_values(complementary_packages, order, 'bank_slip', discount, [bank_slip])
    asserts_basic
    asserts_bank_slip_creation(@order.payments.first)
    asserts_payments_creation(@order.payments.first, 'bank_slip', @prices_paid.first)
    asserts_order_bank_slip_creation
    asserts_payment_response
  end

  def asserts_payments_creation(payment, payment_method, amount, card_token = nil)
    expect(payment.pagarme_transaction).not_to be_nil
    expect(payment.payment_method).to eq payment_method
    expect(payment.card_token).to eq card_token
    expect(payment.amount_in_cents).to eq amount
  end

  def asserts_payments_metadata_creation(payment, card)
    expect(payment.metadata['last4']).to eq card[:last4]
    expect(payment.metadata['brand']).to eq card[:brand]
  end

  def asserts_payments_response_one_payment(card, amount)
    @resp = parsed_response['data']['attributes']
    expect(@resp['status']).to eq('pending')
    expect(@resp['payment-methods']).to eq([{ 'method' => 'card', 'state' => 'pending',
                                              'amount-in-cents' => amount, 'token' => card[:token],
                                              'last4' => card[:last4], 'brand' => card[:brand] }])
  end

  private

  def set_values(complementary_packages, order, checkout_method, discount, payment_method_info)
    @resp = parsed_response['data']['attributes']
    @package = Package.find(complementary_packages.first.package_id)
    child_packages(complementary_packages)
    @complementary_packages_ids = complementary_packages.map(&:id)
    @order = order
    @checkout_method = checkout_method
    @payments_method_info = payment_method_info
    @discount = discount || 0
    prices_paid
  end

  def child_packages(complementary_packages)
    @child_packages = complementary_packages.map { |cp| Package.find(cp.child_package_id) }
    @child_packages_ids = complementary_packages.map { |cp| Package.find(cp.child_package_id).id }
  end

  def prices_paid
    @prices_paid = @payments_method_info.map { |pm_info| pm_info[:amount_in_cents] }
    @total_price_paid = @prices_paid.sum
    @package_price = @package.prices.find_by_price_type(@checkout_method).value
    @cp_prices = @child_packages.map { |cp| cp.prices.find_by_price_type(@checkout_method).value }
  end

  def asserts_package
    @child_packages.each { |cp| expect(ComplementaryPackage.existing(@package, cp)).to eq true }
  end

  def asserts_prices
    expect(@order.price_paid.to_f * 100).to eq((@package_price.to_f * 100) +
                                               (@cp_prices.sum.to_f * 100) - @discount)
  end

  def asserts_order_creation
    expect(@order.complementary_package_ids.sort).to match_array @child_packages_ids.sort
    expect(@order.price_paid.to_f * 100).to eq @total_price_paid
    expect(@order.discount_in_cents).to eq @discount
  end

  def asserts_bank_slip_creation(payment)
    expect(payment.pdf).not_to be_nil
    expect(payment.barcode).not_to be_nil
  end

  def asserts_order_bank_slip_creation
    expect(@order.checkout_method).to eq 'bank_slip'
  end

  def asserts_payment_response
    expect(@resp['status']).to eq('pending')
    expect(@resp['payment-methods']).to eq([{ 'method' => 'bank_slip', 'state' => 'pending',
                                              'amount-in-cents' => @prices_paid.first }])
  end

  def asserts_payments_response_two_payments(card, amount)
    expect(@resp['payment-methods']).to include('state' => 'authorizing', 'token' => card[:token],
                                                'last4' => card[:last4], 'brand' => card[:brand],
                                                'amount-in-cents' => amount, 'method' => 'card')
  end

  def asserts_basic
    asserts_package
    asserts_prices
    asserts_order_creation
  end
end
