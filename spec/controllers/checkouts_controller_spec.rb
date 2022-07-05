# frozen_string_literal: true

require 'rails_helper'
require 'me_salva/crm/users'

RSpec.describe CheckoutsController, type: :controller do
  include CrmEventAssertionHelper
  include CheckoutAssertionHelper

  let!(:package) do
    create(:package_valid_with_price,
           max_payments: 6)
  end

  let(:card_price) do
    Price.by_package_and_price_type(package.id, 'credit_card').value
  end

  let(:discount) do
    create(:discount, packages: [package.id])
  end

  let!(:valid_attributes) do
    FactoryBot.attributes_for(:order_with_address_attributes)
              .merge(package_id: package.id)
  end

  let(:full_user_session) do
    user_session
    add_custom_headers(event_data_headers_with_utm)
  end

  let(:event_data_headers_with_utm) do
    JSON.parse(File.read('spec/fixtures/event_data_headers_with_utm.json'))
  end

  describe 'POST create' do
    let(:pdf) { 'https://pagar.me' }
    let(:card1) do
      { method: ::OrderPayment::Methods::CARD,
        token: "card_ckljewknk0iyn0i9t63o9h49m",
        last4: '1234',
        brand: 'visa',
        amount_in_cents: 400,
        installments: 1 }
    end
    let(:card2) do
      { method: ::OrderPayment::Methods::CARD,
        token: "card_ckljewknk0iyn0i9t63o9h49m",
        last4: '2345',
        brand: 'mastercard',
        amount_in_cents: 600,
        installments: 1 }
    end
    let(:bank_slip) do
      { method: ::OrderPayment::Methods::BANK_SLIP,
        amount_in_cents: 200,
        installments: 1 }
    end

    context 'as user' do
      before { full_user_session }
      context 'with valid attributes' do
        context 'without complementary packages' do
          describe 'single versus multiple payments' do
            context 'package is subscription' do
              context 'by bank slip' do
                it_behaves_like 'a valid subscription' do
                  let(:count_change) { 0 }
                  let(:payment_status) { 'pending' }
                  let(:order_status_count) { 1 }
                  let(:status) { 'pending' }
                  let(:payment_method) { bank_slip }
                end
              end

              context 'by card' do
                context 'with valid attributes' do
                  it_behaves_like 'a valid subscription' do
                    let(:payment_method) { card1 }
                    let(:order_status_count) { 2 }
                    let(:count_change) { 1 }
                    let(:status) { 'paid' }
                    let(:payment_status) { 'captured' }
                  end
                end

                context 'with PagarMe Validation Error' do
                  before do
                    package.update(subscription: true)
                    package.update(pagarme_plan_id: 172_945)
                    card1[:amount_in_cents] = 1000
                    card1[:token] = 'invalid'
                    valid_attributes[:payment_methods] = [card1]
                  end

                  it 'should creates event and intercom call' do |example|
                    VCR.use_cassette(test_name(example)) do
                      expect(UpdateIntercomUserWorker)
                        .to receive(:perform_async).twice
                      expect(PersistCrmEventWorker).to receive(
                        :perform_async
                      ).twice
                      post :create, params: valid_attributes

                      assert_type_and_status(:unprocessable_entity)
                    end
                  end
                end
              end
            end

            context 'one card as payment method' do
              before do
                card1[:amount_in_cents] = 1000
                valid_attributes[:payment_methods] = [card1]
              end
              context 'without address' do
                it 'creates one payment' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: valid_attributes.except(
                        :address_attributes
                      )
                    end.to change(::Order, :count)
                      .by(1).and change(::OrderPayment, :count).by(1)
                    order = ::Order.last
                    payment = order.payments.last

                    expect(order.discount_in_cents).to eq 0
                    asserts_payments_creation(payment, 'card', 1000, card1[:token])
                    asserts_payments_metadata_creation(payment, card1)
                    asserts_payments_response_one_payment(card1, 1000)
                  end
                end
              end

              context 'without discount' do
                it 'creates one payment' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: valid_attributes
                    end.to change(::Order, :count)
                      .by(1).and change(::OrderPayment, :count).by(1)

                    order = ::Order.last
                    payment = order.payments.last

                    expect(order.discount_in_cents).to eq 0
                    asserts_payments_creation(payment, 'card', 1000, card1[:token])
                    asserts_payments_metadata_creation(payment, card1)
                    asserts_payments_response_one_payment(card1, 1000)
                  end
                end
              end

              context 'with discount' do
                before do
                  card1[:amount_in_cents] = 800
                  valid_attributes[:payment_methods] = [card1]
                  valid_attributes['discount_id'] = discount.token
                end
                it 'creates one payment' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: valid_attributes
                    end.to change(::Order, :count)
                      .by(1).and change(::OrderPayment, :count).by(1)

                    order = ::Order.last
                    payment = order.payments.last

                    expect(order.discount_in_cents).to eq 200
                    expect(order.price_paid).to eq 8.0
                    asserts_payments_creation(payment, 'card', 800, card1[:token])
                    asserts_payments_metadata_creation(payment, card1)
                    asserts_payments_response_one_payment(card1, 800)
                  end
                end
              end
            end

            context 'with discount for only costumer' do
              context 'within the only costumer valid period' do
                context 'with a valid access' do
                  let!(:access) do
                    create(:access_with_duration,
                           expires_at: Date.today + 30.days,
                           package: package,
                           user_id: user.id)
                  end
                  let!(:discount_only_customer) do
                    create(:discount_only_customer, packages: [package.id])
                  end
                  before do
                    card1[:amount_in_cents] = 700
                    valid_attributes[:payment_methods] = [card1]
                    valid_attributes['discount_id'] = discount_only_customer.token
                  end
                  it 'creates one payment' do |example|
                    VCR.use_cassette(test_name(example)) do
                      expect do
                        post :create, params: valid_attributes
                      end.to change(::Order, :count)
                        .by(1).and change(::OrderPayment, :count).by(1)

                      order = ::Order.last
                      payment = order.payments.last

                      expect(order.discount_in_cents).to eq 300
                      expect(order.price_paid).to eq 7.0
                      asserts_payments_creation(payment, 'card', 700, card1[:token])
                      asserts_payments_metadata_creation(payment, card1)
                      asserts_payments_response_one_payment(card1, 700)
                    end
                  end
                end
                context 'with an expired access' do
                  let!(:access) do
                    create(:access_with_duration,
                           expires_at: Date.today - 15.days,
                           active: false,
                           package: package,
                           user_id: user.id)
                  end
                  let!(:discount_only_customer) do
                    create(:discount_only_customer, packages: [package.id])
                  end
                  before do
                    card1[:amount_in_cents] = 700
                    valid_attributes[:payment_methods] = [card1]
                    valid_attributes['discount_id'] = discount_only_customer.token
                  end
                  it 'creates one payment' do |example|
                    VCR.use_cassette(test_name(example)) do
                      expect do
                        post :create, params: valid_attributes
                      end.to change(::Order, :count)
                        .by(1).and change(::OrderPayment, :count).by(1)

                      order = ::Order.last
                      payment = order.payments.last

                      expect(order.discount_in_cents).to eq 300
                      expect(order.price_paid).to eq 7.0
                      asserts_payments_creation(payment, 'card', 700, card1[:token])
                      asserts_payments_metadata_creation(payment, card1)
                      asserts_payments_response_one_payment(card1, 700)
                    end
                  end
                end
              end
              context 'with access out of only costumer rule range' do
                let!(:discount_only_customer) do
                  create(:discount_only_customer, packages: [package.id])
                end
                before do
                  card1[:amount_in_cents] = 700
                  valid_attributes[:payment_methods] = [card1]
                  valid_attributes['discount_id'] = discount_only_customer.token
                end
                context 'before the last 30 days of access' do
                  let!(:access) do
                    create(:access_with_duration,
                           expires_at: Date.today + 31.days,
                           package: package,
                           user_id: user.id)
                  end
                  it 'do not create a payment' do |example|
                    VCR.use_cassette(test_name(example)) do
                      expect do
                        post :create, params: valid_attributes
                      end.to change(::Order, :count)
                        .by(0).and change(::OrderPayment, :count).by(0)
                    end
                  end
                end
                context 'after the first 15 days of expired access' do
                  let!(:access) do
                    create(:access_with_duration,
                           expires_at: Date.today - 16.days,
                           package: package,
                           user_id: user.id)
                  end
                  it 'do not create a payment' do |example|
                    VCR.use_cassette(test_name(example)) do
                      expect do
                        post :create, params: valid_attributes
                      end.to change(::Order, :count)
                        .by(0).and change(::OrderPayment, :count).by(0)
                    end
                  end
                end
              end
            end

            context 'one bank slip as payment method' do
              before do
                bank_slip[:amount_in_cents] = 1000
                valid_attributes[:payment_methods] = [bank_slip]
                expect(CrmRdstationBankSlipWorker).to receive(:perform_async)
              end

              it 'creates one payment' do |example|
                VCR.use_cassette(test_name(example)) do
                  expect do
                    post :create, params: valid_attributes
                  end.to change(::Order, :count)
                    .by(1).and change(::OrderPayment, :count)
                    .by(1).and change(ActionMailer::Base.deliveries, :count)
                    .by(1)

                  order = ::Order.last
                  payment = order.payments.first

                  expect(payment.pagarme_transaction).not_to be_nil
                  expect(payment.pdf).not_to be_nil
                  expect(payment.barcode).not_to be_nil

                  expect(order.checkout_method).to eq 'bank_slip'
                  expect(payment.payment_method).to eq 'bank_slip'
                  expect(payment.card_token).to eq nil
                  expect(payment.amount_in_cents).to eq 1000

                  attrs_response = parsed_response['data']['attributes']
                  expect(attrs_response['status']).to eq('pending')
                  expect(attrs_response['payment-methods'])
                    .to eq([{ 'method' => 'bank_slip',
                              'amount-in-cents' => 1000,
                              'state' => 'pending' }])
                end
              end
            end

            context 'with PagarMe Validation Error' do
              before do
                user_session
                card1[:amount_in_cents] = 1000
                card1[:token] = 'invalid'
                valid_attributes[:payment_methods] = [card1]
              end
              it 'should create event and intercom call' do |example|
                VCR.use_cassette(test_name(example)) do
                  expect(UpdateIntercomUserWorker)
                    .to receive(:perform_async).twice
                  expect(PersistCrmEventWorker).to receive(:perform_async).twice
                  post :create, params: valid_attributes

                  assert_type_and_status(:unprocessable_entity)
                end
              end
            end

            context 'two cards as payment methods' do
              before { valid_attributes[:payment_methods] = [card1, card2] }

              it 'creates multiple payments' do |example|
                VCR.use_cassette(test_name(example)) do
                  expect do
                    post :create, params: valid_attributes
                  end.to change(::Order, :count)
                    .by(1).and change(::OrderPayment, :count).by(2)

                  order = ::Order.last
                  payment1 = order.payments.first
                  payment2 = order.payments.last

                  attrs_response = parsed_response['data']['attributes']
                  expect(attrs_response['status']).to eq('pending')

                  expect(payment1.pagarme_transaction).not_to be_nil
                  expect(payment2.pagarme_transaction).not_to be_nil

                  expect(payment1.payment_method).to eq 'card'
                  expect(payment1.card_token).to eq card1[:token]
                  expect(payment1.amount_in_cents).to eq 400
                  expect(payment1.metadata['last4']).to eq '1234'
                  expect(payment1.metadata['brand']).to eq 'visa'
                  expect(payment2.payment_method).to eq 'card'
                  expect(payment2.card_token).to eq card2[:token]
                  expect(payment2.amount_in_cents).to eq 600
                  expect(payment2.metadata['last4']).to eq '2345'
                  expect(payment2.metadata['brand']).to eq 'mastercard'

                  expect(attrs_response['payment-methods'])
                    .to include('method' => 'card',
                                'token' => card1[:token],
                                'last4' => '1234',
                                'brand' => 'visa',
                                'amount-in-cents' => 400,
                                'state' => 'authorizing')

                  expect(attrs_response['payment-methods'])
                    .to include('method' => 'card',
                                'token' => card2[:token],
                                'last4' => '2345',
                                'brand' => 'mastercard',
                                'amount-in-cents' => 600,
                                'state' => 'authorizing')
                end
              end
            end

            context 'one card and one bank slip as payment method' do
              before do
                card1[:amount_in_cents] = 800
                bank_slip[:amount_in_cents] = 200
                valid_attributes[:payment_methods] = [card1, bank_slip]
              end

              it 'creates multiple payments' do |example|
                VCR.use_cassette(test_name(example)) do
                  expect do
                    post :create, params: valid_attributes
                  end.to change(::Order, :count)
                    .by(1).and change(::OrderPayment, :count).by(2)

                  order = ::Order.last
                  payment1 = order.payments.first
                  payment2 = order.payments.last

                  attrs_response = parsed_response['data']['attributes']
                  expect(attrs_response['status']).to eq('pending')

                  expect(payment1.pagarme_transaction).not_to be_nil
                  expect(payment2.pagarme_transaction).not_to be_nil

                  expect(order.checkout_method).to eq 'multiple'
                  expect(payment1.payment_method).to eq 'card'
                  expect(payment1.card_token).to eq card1[:token]
                  expect(payment1.amount_in_cents).to eq 800
                  expect(payment1.metadata['last4']).to eq '1234'
                  expect(payment1.metadata['brand']).to eq 'visa'
                  expect(payment2.payment_method).to eq 'bank_slip'
                  expect(payment2.card_token).to eq nil
                  expect(payment2.amount_in_cents).to eq 200

                  expect(attrs_response['payment-methods'])
                    .to include('method' => 'card',
                                'token' => card1[:token],
                                'last4' => '1234',
                                'brand' => 'visa',
                                'amount-in-cents' => 800,
                                'state' => 'authorizing')
                  expect(attrs_response['payment-methods'])
                    .to include('method' => 'bank_slip',
                                'amount-in-cents' => 200,
                                'state' => 'pending')
                end
              end
            end

            context 'one card and two bank slips as payment method' do
              before do
                valid_attributes[:payment_methods] = [card1, bank_slip, bank_slip]
              end

              it 'returns an error' do
                expect do
                  post :create, params: valid_attributes
                end.to change(::Order, :count)
                  .by(0).and change(::OrderPayment, :count).by(0)

                expect(parsed_response).to include('errors')
                assert_type_and_status(:unprocessable_entity)
              end
            end

            describe 'invalid payment payload' do
              context 'when amounts don\'t match package\'s price' do
                context 'without discount' do
                  before do
                    expect(DecimalAmount.new(card_price).to_i).to eq 1000
                    card1[:amount_in_cents] = 600
                    card2[:amount_in_cents] = 700
                    valid_attributes[:payment_methods] = [card1, card2]
                  end

                  it 'returns errors' do
                    assert_payments_value_error
                  end
                end

                context 'with discount' do
                  before do
                    expect(DecimalAmount.new(card_price).to_i).to eq 1000
                    card1[:amount_in_cents] = 500
                    card2[:amount_in_cents] = 500
                    valid_attributes[:payment_methods] = [card1, card2]
                    valid_attributes['discount_id'] = discount.token
                  end

                  it 'returns errors' do
                    assert_payments_value_error
                  end
                end
              end

              context 'when payment method attrs are invalid' do
                before do
                  card1[:method] = 'whatever'
                  valid_attributes[:payment_methods] = [card1, card2]
                end

                it 'returns errors' do
                  expect do
                    post :create, params: valid_attributes
                  end.to change(::Order, :count).by(0)

                  expect(parsed_response).to eq(
                    "errors" => [{
                      "payments.payment_method" => [
                        "não está incluído na lista"
                      ]
                    }]
                  )
                end
              end

              context 'when discount are invalid' do
                before do
                  valid_attributes['discount_id'] = 'invalid_token'
                end

                it 'returns errors' do
                  expect do
                    post :create, params: valid_attributes
                  end.to change(::Order, :count).by(0)
                  assert_type_and_status(:unprocessable_entity)
                  expect(parsed_response).to eq(
                    'errors' => ['Desconto inválido.']
                  )
                end
              end
            end
          end
        end

        context 'with complementary package' do
          context 'with only one complementary package' do
            let!(:child_package) { create(:package_valid_with_price) }
            before { child_package.prices.each { |price| price.update(value: '0.08e2') } }
            let!(:complementary_package) do
              create(:complementary_package,
                     package_id: package.id,
                     child_package_id: child_package.id)
            end
            let!(:cp) { [complementary_package] }
            let!(:cp_valid_attributes) do
              valid_attributes.merge(complementary_package_ids: cp.pluck(:child_package_id))
            end
            context 'one card as payment method' do
              before do
                card1[:amount_in_cents] = 1800
                cp_valid_attributes[:payment_methods] = [card1]
                cp_valid_attributes[:checkout_method] = ['credit_card']
              end
              context 'without discount' do
                it 'creates checkout with one card payment without discount ' \
                   'for one complementary package' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(1)
                    asserts_one_card_payment(cp, ::Order.last, card1)
                  end
                end
              end
              context 'with discount' do
                before do
                  card1[:amount_in_cents] = 1440
                  cp_valid_attributes[:payment_methods] = [card1]
                  cp_valid_attributes[:checkout_method] = ['credit_card']
                  cp_valid_attributes['discount_id'] = discount.token
                end
                it 'creates checkout with one card payment with discount ' \
                   'for one complementary package' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(1)
                    asserts_one_card_payment(cp, ::Order.last, card1, 360)
                  end
                end
              end
            end
            context 'two cards as payment method' do
              context 'without discount' do
                before do
                  card1[:amount_in_cents] = 700
                  card2[:amount_in_cents] = 1100
                  cp_valid_attributes[:payment_methods] = [card1, card2]
                  cp_valid_attributes[:checkout_method] = ['credit_card']
                end
                it 'creates checkout with two card payments without discount ' \
                   'for one complementary package' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(2)
                    asserts_two_cards_payment(cp, ::Order.last, [card1, card2])
                  end
                end
              end
              context 'with discount' do
                before do
                  card1[:amount_in_cents] = 340
                  card2[:amount_in_cents] = 1100
                  cp_valid_attributes[:payment_methods] = [card1, card2]
                  cp_valid_attributes[:checkout_method] = ['credit_card']
                  cp_valid_attributes['discount_id'] = discount.token
                end
                it 'creates checkout with two card payments with discount ' \
                   'for one complementary package' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(2)
                    asserts_two_cards_payment(cp, ::Order.last, [card1, card2], 360)
                  end
                end
              end
            end
            context 'bank slip as payment method' do
              context 'without discount' do
                before do
                  bank_slip[:amount_in_cents] = 1800
                  cp_valid_attributes[:payment_methods] = [bank_slip]
                  cp_valid_attributes[:checkout_method] = ['bank_slip']
                  expect(CrmRdstationBankSlipWorker).to receive(:perform_async)
                end
                it 'creates checkout with one bank slip payment without discount ' \
                   'for one complementary package' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(1)
                    asserts_bank_slip_payment(cp, ::Order.last, bank_slip)
                  end
                end
              end
              context 'with discount' do
                before do
                  bank_slip[:amount_in_cents] = 1440
                  cp_valid_attributes[:payment_methods] = [bank_slip]
                  cp_valid_attributes[:checkout_method] = ['bank_slip']
                  cp_valid_attributes['discount_id'] = discount.token
                  expect(CrmRdstationBankSlipWorker).to receive(:perform_async)
                end
                it 'creates checkout with one bank slip payment with discount ' \
                   'for one complementary package' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(1)
                    asserts_bank_slip_payment(cp, ::Order.last, bank_slip, 360)
                  end
                end
              end
            end
          end
          context 'with two complementary packages' do
            let!(:child_package1) { create(:package_valid_with_price) }
            let!(:child_package2) { create(:package_valid_with_price) }
            before { child_package1.prices.each { |price| price.update(value: '0.08e2') } }
            before { child_package2.prices.each { |price| price.update(value: '0.06e2') } }
            let!(:complementary_package1) do
              create(:complementary_package,
                     package_id: package.id,
                     child_package_id: child_package1.id)
            end
            let!(:complementary_package2) do
              create(:complementary_package,
                     package_id: package.id,
                     child_package_id: child_package2.id)
            end
            let!(:cp) { [complementary_package1, complementary_package2] }
            let!(:cp_valid_attributes) do
              valid_attributes.merge(complementary_package_ids: cp.pluck(:child_package_id))
            end
            context 'one card as payment method' do
              before do
                card1[:amount_in_cents] = 2400
                cp_valid_attributes[:payment_methods] = [card1]
                cp_valid_attributes[:checkout_method] = ['credit_card']
              end
              context 'without discount' do
                it 'creates checkout with one card payment without discount ' \
                   'for two complementary packages' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(1)
                    asserts_one_card_payment(cp, ::Order.last, card1)
                  end
                end
              end
              context 'with discount' do
                before do
                  card1[:amount_in_cents] = 1920
                  cp_valid_attributes[:payment_methods] = [card1]
                  cp_valid_attributes[:checkout_method] = ['credit_card']
                  cp_valid_attributes['discount_id'] = discount.token
                end
                it 'creates checkout with one card payment with discount ' \
                   'for two complementary packages' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(1)
                    asserts_one_card_payment(cp, ::Order.last, card1, 480)
                  end
                end
              end
            end
            context 'two cards as payment method' do
              context 'without discount' do
                before do
                  card1[:amount_in_cents] = 900
                  card2[:amount_in_cents] = 1500
                  cp_valid_attributes[:payment_methods] = [card1, card2]
                  cp_valid_attributes[:checkout_method] = ['credit_card']
                end
                it 'creates checkout with two card payments without discount ' \
                   'for two complementary packages' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(2)
                    asserts_two_cards_payment(cp, ::Order.last, [card1, card2])
                  end
                end
              end
              context 'with discount' do
                before do
                  card1[:amount_in_cents] = 420
                  card2[:amount_in_cents] = 1500
                  cp_valid_attributes[:payment_methods] = [card1, card2]
                  cp_valid_attributes[:checkout_method] = ['credit_card']
                  cp_valid_attributes['discount_id'] = discount.token
                end
                it 'creates checkout with two card payments with discount ' \
                   'for two complementary packages' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(2)
                    asserts_two_cards_payment(cp, ::Order.last, [card1, card2], 480)
                  end
                end
              end
            end
            context 'bank slip as payment method' do
              context 'without discount' do
                before do
                  bank_slip[:amount_in_cents] = 2400
                  cp_valid_attributes[:payment_methods] = [bank_slip]
                  cp_valid_attributes[:checkout_method] = ['bank_slip']
                  expect(CrmRdstationBankSlipWorker).to receive(:perform_async)
                end
                it 'creates checkout with one bank slip payment without discount ' \
                   'for two complementary packages' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(1)
                    asserts_bank_slip_payment(cp, ::Order.last, bank_slip)
                  end
                end
              end
              context 'with discount' do
                before do
                  bank_slip[:amount_in_cents] = 1920
                  cp_valid_attributes[:payment_methods] = [bank_slip]
                  cp_valid_attributes[:checkout_method] = ['bank_slip']
                  cp_valid_attributes['discount_id'] = discount.token
                  expect(CrmRdstationBankSlipWorker).to receive(:perform_async)
                end
                it 'creates checkout with one bank slip payment with discount ' \
                   'for two complementary packages' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(1)
                    asserts_bank_slip_payment(cp, ::Order.last, bank_slip, 480)
                  end
                end
              end
            end
          end
          context 'with three complementary packages' do
            let!(:child_package1) { create(:package_valid_with_price) }
            let!(:child_package2) { create(:package_valid_with_price) }
            let!(:child_package3) { create(:package_valid_with_price) }
            before { child_package1.prices.each { |price| price.update(value: '0.08e2') } }
            before { child_package2.prices.each { |price| price.update(value: '0.06e2') } }
            before { child_package3.prices.each { |price| price.update(value: '0.04e2') } }
            let!(:complementary_package1) do
              create(:complementary_package,
                     package_id: package.id,
                     child_package_id: child_package1.id)
            end
            let!(:complementary_package2) do
              create(:complementary_package,
                     package_id: package.id,
                     child_package_id: child_package2.id)
            end
            let!(:complementary_package3) do
              create(:complementary_package,
                     package_id: package.id,
                     child_package_id: child_package3.id)
            end
            let!(:cp) { [complementary_package1, complementary_package2, complementary_package3] }
            let!(:cp_valid_attributes) do
              valid_attributes.merge(complementary_package_ids: cp.pluck(:child_package_id))
            end
            context 'one card as payment method' do
              before do
                card1[:amount_in_cents] = 2800
                cp_valid_attributes[:payment_methods] = [card1]
                cp_valid_attributes[:checkout_method] = ['credit_card']
              end
              context 'without discount' do
                it 'creates checkout with one card payment without discount ' \
                   'for three complementary packages' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(1)
                    asserts_one_card_payment(cp, ::Order.last, card1)
                  end
                end
              end
              context 'with discount' do
                before do
                  card1[:amount_in_cents] = 2240
                  cp_valid_attributes[:payment_methods] = [card1]
                  cp_valid_attributes[:checkout_method] = ['credit_card']
                  cp_valid_attributes['discount_id'] = discount.token
                end
                it 'creates checkout with one card payment with discount ' \
                   'for three complementary packages' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(1)
                    asserts_one_card_payment(cp, ::Order.last, card1, 560)
                  end
                end
              end
            end
            context 'two cards as payment method' do
              context 'without discount' do
                before do
                  card1[:amount_in_cents] = 1000
                  card2[:amount_in_cents] = 1800
                  cp_valid_attributes[:payment_methods] = [card1, card2]
                  cp_valid_attributes[:checkout_method] = ['credit_card']
                end
                it 'creates checkout with two card payments without discount ' \
                   'for three complementary packages' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(2)
                    asserts_two_cards_payment(cp, ::Order.last, [card1, card2])
                  end
                end
              end
              context 'with discount' do
                before do
                  card1[:amount_in_cents] = 440
                  card2[:amount_in_cents] = 1800
                  cp_valid_attributes[:payment_methods] = [card1, card2]
                  cp_valid_attributes[:checkout_method] = ['credit_card']
                  cp_valid_attributes['discount_id'] = discount.token
                end
                it 'creates checkout with two card payments with discount ' \
                   'for three complementary packages' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(2)
                    asserts_two_cards_payment(cp, ::Order.last, [card1, card2], 560)
                  end
                end
              end
            end
            context 'bank slip as payment method' do
              context 'without discount' do
                before do
                  bank_slip[:amount_in_cents] = 2800
                  cp_valid_attributes[:payment_methods] = [bank_slip]
                  cp_valid_attributes[:checkout_method] = ['bank_slip']
                  expect(CrmRdstationBankSlipWorker).to receive(:perform_async)
                end
                it 'creates checkout with one bank slip payment without discount ' \
                   'for three complementary packages' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(1)
                    asserts_bank_slip_payment(cp, ::Order.last, bank_slip)
                  end
                end
              end
              context 'with discount' do
                before do
                  bank_slip[:amount_in_cents] = 2240
                  cp_valid_attributes[:payment_methods] = [bank_slip]
                  cp_valid_attributes[:checkout_method] = ['bank_slip']
                  cp_valid_attributes['discount_id'] = discount.token
                end
                it 'creates checkout with one bank slip payment with discount ' \
                   'for three complementary packages' do |example|
                  VCR.use_cassette(test_name(example)) do
                    expect do
                      post :create, params: cp_valid_attributes
                    end.to change(::Order, :count).by(1).and change(::OrderPayment, :count).by(1)
                    asserts_bank_slip_payment(cp, ::Order.last, bank_slip, 560)
                  end
                end
              end
            end
          end
        end
      end

      context 'with invalid attributes' do
        let(:invalid_attributes) { FactoryBot.attributes_for(:order) }
        it 'returns unprocessable_entity status' do
          user_session

          expect do
            post :create, params: invalid_attributes
          end.to change(Order, :count).by(0)

          assert_type_and_status(:unprocessable_entity)
        end
      end
    end

    context 'without authentication' do
      it 'returns unauthorized status' do
        post :create, params: valid_attributes

        assert_type_and_status(:unauthorized)
      end
    end

    context 'with inactive package' do
      let!(:inactive_package_attributes) do
        FactoryBot.attributes_for(:order_with_address_attributes)
                  .merge(package_id: inactive_package.id)
      end
      let!(:inactive_package) do
        create(:package_valid_with_price, :inactive)
      end
      it 'does not allow the creation of an order' do
        user_session
        post :create, params: inactive_package_attributes

        assert_type_and_status(:unprocessable_entity)
      end
    end
  end

  def assert_payments_value_error
    expect do
      post :create, params: valid_attributes
    end.to change(::Order, :count).by(0)

    expect(parsed_response).to eq(
      'errors' => [{ 'payments' => [
        'Pagamentos devem somar e ser igual ao preço do pacote'
      ] }]
    )
  end
end
