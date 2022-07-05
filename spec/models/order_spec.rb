# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  context 'validations' do
    should_be_present(:package, :user, :broker)
    should_have_many(:payments, :accesses)
    it { should validate_inclusion_of(:broker).in_array(Order::Brokers::ALL) }
    it { should validate_uniqueness_of :token }

    describe '.set_default_attributes' do
      context 'when is first user purchase' do
        subject { create(:order_valid) }
        it 'purchase type should be 1' do
          expect(subject.purchase_type).to eq(1)
        end
      end

      context 'when is repurchase' do
        let(:user) { create(:user) }
        subject { create(:order_valid, user: user) }
        subject { create(:order_valid, user: user) }
        it 'purchase type should be 3' do
          expect(subject.purchase_type).to eq(3)
        end
      end

      context 'when is subscription user purchase' do
        let(:user) { create(:user) }
        let(:subscription) { create(:subscription, user: user) }
        it 'first purchase type should be 1' do
          expect(subscription.orders.first.purchase_type).to eq(1)
        end

        it 'when renew purchase type should be 2' do
          next_order = create(:order_valid, user: user,
                                            subscription: subscription)
          expect(next_order.purchase_type).to eq(2)
        end
      end
    end

    describe 'deprecated methods' do
      methods = %w[bank_slip credit_card]

      context 'payments are not included' do
        before { expect(subject.payments).to be_blank }
        it { should validate_inclusion_of(:checkout_method).in_array(methods) }
      end

      context 'only deprecated key is included' do
        before { subject.payments = [::OrderPayment.new] }
        it { should_not validate_inclusion_of(:checkout_method) }
      end
    end

    describe 'bank slips' do
      let(:bank_slip) { create(:payment, :bank_slip) }
      let(:bank_slip2) { create(:payment, :bank_slip) }

      subject { create(:order_valid) }

      context 'zero bank slips' do
        before { subject.payments = [] }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'one bank slip' do
        before { subject.payments = [bank_slip] }

        it 'is valid' do
          expect(subject).to be_valid
        end
      end

      context 'multiple bank slips' do
        before { subject.payments = [bank_slip, bank_slip2] }

        it 'is invalid' do
          expect(subject).to_not be_valid
        end
      end
    end

    describe 'payment amounts' do
      subject { build(:order_valid) }

      before do
        expect(DecimalAmount.new(subject.price.value).to_i).to eq 1000
      end

      context 'without discount' do
        context 'when payments sum up to the package price' do
          before do
            subject.payments = [
              build(:payment, amount_in_cents: 200),
              build(:payment, amount_in_cents: 800)
            ]
          end

          it { should be_valid }
        end

        before do
          subject.payments = [
            build(:payment, amount_in_cents: 600),
            build(:payment, amount_in_cents: 700)
          ]
        end
        context 'when payments do not sum up to the package price' do
          context 'with a web broker order' do
            it { should_not be_valid }
          end

          context 'in app order' do
            before do
              subject.broker = 'app_store'
            end
            it { should be_valid }
          end
        end
      end

      context 'with discount' do
        context 'when payments sum up to the package price' do
          before do
            subject.payments = [
              build(:payment, amount_in_cents: 300),
              build(:payment, amount_in_cents: 500)
            ]
            subject.discount_in_cents = 200
          end

          it { should be_valid }
        end

        context 'when payments do not sum up to the package price' do
          before do
            subject.payments = [
              build(:payment, amount_in_cents: 500),
              build(:payment, amount_in_cents: 500)
            ]
            subject.discount_in_cents = 200
          end

          it { should_not be_valid }
        end
      end
    end

    describe '.valid_play_store_invoice' do
      subject { build(:order_valid) }

      context 'when a valid recurrence representation is informed' do
        it { should be_valid }
      end
      context 'when an invalid recurrence representation is informed' do
        before do
          subject.broker = 'play_store'
          subject.broker_invoice = '3270562479901159870.9183678832509714'
        end

        it { should_not be_valid }
      end
    end
  end

  let!(:package_subscription) { create(:package_subscription) }
  let!(:access_package) { create(:package_valid_with_price) }
  let!(:subscription) { create(:subscription) }
  let!(:subscription_suspended) do
    create(:subscription, active: false)
  end

  let!(:user) { create(:user) }

  let!(:order_pending_bank_slip) { create(:pending_order) }

  let!(:order_pending_credit_card) do
    create(:pending_order, checkout_method: 'credit_card')
  end

  let!(:expired_subscription_order) do
    create(:order_expired,
           package_id: package_subscription.id,
           subscription_id: subscription.id)
  end

  let!(:order_active) do
    create(:order_with_expiration_date,
           status: 2,
           package_id: package_subscription.id,
           user_id: user.id)
  end

  let(:order_with_utm) do
    FactoryBot.attributes_for(:order_with_address_attributes,
                              :with_utm_attributes)
  end

  let(:order_utm_blank) do
    FactoryBot.attributes_for(:order_with_address_attributes,
                              :with_utm_attributes_blank)
  end

  let!(:subscription_pending) do
    create(:pending_order,
           package_id: package_subscription.id)
  end

  let!(:access_pending) { create(:pending_order) }

  context '#utm_attributes' do
    context 'with utm attributes' do
      it 'creates a new order with utm' do
        expect do
          Order.create(order_with_utm.merge(user: user)
                                     .merge(package: package_subscription))
        end.to change(Order, :count).by(1)
                                    .and change(Utm, :count).by(1)
      end
    end

    context 'with utm source blank' do
      it 'creates a new order without utm' do
        expect do
          Order.create(order_utm_blank.merge(user: user)
                                      .merge(package: package_subscription))
        end.to change(Order, :count).by(1)
                                    .and change(Utm, :count).by(0)
      end
    end
  end

  context 'scopes' do
    let!(:suspended_order) do
      create(:order_expired,
             package_id: package_subscription.id,
             subscription_id: subscription_suspended.id)
    end

    describe '.pending' do
      it 'get pending orders' do
        scope = Order.pending
        expect(scope).to include(order_pending_credit_card,
                                 order_pending_bank_slip,
                                 subscription_pending,
                                 access_pending)
      end
    end

    describe 'brokers scopes' do
      let!(:iugu_order) { create(:order_valid, broker: 'iugu') }
      let!(:pagarme_order) do
        create(:order_valid, broker: 'pagarme')
      end
      let!(:play_store_order) do
        create(:in_app_order, broker: 'play_store')
      end
      let!(:app_store_order) do
        create(:order_valid, broker: 'app_store')
      end

      describe '.by_iugu' do
        it 'get iugu orders only' do
          iugu_orders = Order.by_iugu
          expect(iugu_orders).to include(iugu_order)
          expect(iugu_orders).not_to include(pagarme_order, play_store_order,
                                             app_store_order)
        end
      end

      describe '.by_play_store' do
        it 'get play_store orders only' do
          play_store_orders = Order.by_play_store
          expect(play_store_orders).to include(play_store_order)
          expect(play_store_orders).not_to include(pagarme_order, iugu_order,
                                                   app_store_order)
        end
      end
    end

    describe 'expired orders scopes' do
      let!(:expired_order) do
        create(:order_expired)
      end
      let!(:processed_order) do
        create(:order_expired, processed: true)
      end

      describe '.expired_subscription_orders' do
        it 'get order unprocessed with status paid, expires_at < Time.now and \
            with a subscription' do
          scope = Order.expired_subscription_orders
          expect(scope).to include(expired_subscription_order, suspended_order)
          expect(scope).not_to include(expired_order, processed_order)
        end
      end

      describe '.expired_orders' do
        it 'returns unprocessed and expired orders with status paid' do
          expired_orders = Order.expired_orders
          expect(expired_orders).to include(expired_subscription_order,
                                            suspended_order, expired_order)
          expect(expired_orders).not_to include(processed_order)
        end
      end
    end

    describe '.pending_order_subscriptions' do
      it 'get subscription pending' do
        scope = Order.pending_order_subscriptions
        expect(scope).to eq([subscription_pending])
      end
    end

    describe '.pending_order_one_shots' do
      it 'get access_package pending' do
        scope = Order.pending_order_one_shots
        expect(scope).to include(order_pending_credit_card,
                                 order_pending_bank_slip,
                                 access_pending)
      end
    end

    describe '.pending_order_one_shots_credit_card' do
      it 'get access_package pending with checkout_method credit_card' do
        scope = Order.pending_order_one_shots_credit_card
        expect(scope).to include(order_pending_credit_card)
      end
    end

    describe '.pending_order_one_shots_bank_slip' do
      it 'get access_package pending with checkout_method bank_slip' do
        scope = Order.pending_order_one_shots_bank_slip
        expect(scope).to include(order_pending_bank_slip, access_pending)
      end
    end

    describe '.by_user' do
      it 'get order finded by user ordered by desc' do
        user2 = create(:user)
        create(:order_with_expiration_date,
               status: 2,
               package_id: package_subscription.id,
               user_id: user2.id)

        last_order = create(:order_with_expiration_date,
                            status: 2,
                            package_id: package_subscription.id,
                            user_id: user.id)
        scope = Order.by_user(user.id)
        expect(scope).to eq([last_order, order_active])
      end
    end

    describe '.buzzlead_expired' do
      let(:updated_at) { (Time.now - 8.days) }
      let!(:order_buzzlead) do
        create(:order_valid, :with_utm_buzzlead, :paid, updated_at: updated_at)
      end
      before do
        create(:order_valid, :with_utm_attributes, :paid,
               updated_at: updated_at)
        create(:order_valid, :with_utm_buzzlead)
        create(:order_valid, :with_utm_buzzlead, :paid)
        create(:order_valid, :with_utm_buzzlead, :paid,
               updated_at: updated_at, buzzlead_processed: true)
      end

      it 'return orders with utm buzzlead and expired' do
        expect(Order.buzzlead_expired).to eq([order_buzzlead])
      end
    end
  end

  context 'many orders each with it own payment' do
    let!(:order1) { create(:order_valid) }
    let!(:order2) { create(:order_valid) }
    let!(:order3) { create(:order_valid) }
    let!(:card1) { create(:payment, :card, order: order1) }
    let!(:card2) { create(:payment, :card, order: order2) }
    let!(:card3) { create(:payment, :card, order: order3) }

    context 'payments' do
      it 'should returns only one payment' do
        expect(order1.reload.payments).to eq([card1])
      end
    end
  end

  describe '#iugu?' do
    let(:subject) { Order.new(broker: broker) }

    context 'when iugu' do
      let(:broker) { 'iugu' }

      it 'returns true' do
        expect(subject).to be_iugu
      end
    end

    context 'when not iugu' do
      let(:broker) { 'pagarme' }

      it 'returns false' do
        expect(subject).to_not be_iugu
      end
    end
  end

  describe '#pagarme?' do
    let(:subject) { Order.new(broker: broker) }

    context 'when pagarme' do
      let(:broker) { 'pagarme' }

      it 'returns true' do
        expect(subject).to be_pagarme
      end
    end

    context 'when not pagarme' do
      let(:broker) { 'iugu' }

      it 'returns false' do
        expect(subject).to_not be_pagarme
      end
    end
  end

  describe '#price' do
    let(:order) { build(:order_valid, checkout_method: checkout_method) }
    let(:price) { build(:price) }

    context 'when checkout_method is cc' do
      let(:checkout_method) { 'credit_card' }

      it 'returns the price for the order' do
        allow(::Price)
          .to receive(:by_package_and_price_type)
          .with(order.package.id, 'credit_card')
          .and_return(price)

        expect(order.price).to eq price
      end
    end

    context 'when checkout_method is bank_slip' do
      let(:checkout_method) { 'bank_slip' }

      it 'returns the price for the order' do
        allow(::Price)
          .to receive(:by_package_and_price_type)
          .with(order.package.id, 'bank_slip')
          .and_return(price)

        expect(order.price).to eq price
      end
    end
  end

  describe '#price_method' do
    let(:card) { build(:payment, :card) }
    let(:bank_slip) { build(:payment, :bank_slip) }

    context 'when one payment' do
      before do
        subject.payments = [bank_slip]
      end

      it 'returns the payment method itself' do
        expect(subject.price_method).to eq 'bank_slip'
      end
    end

    context 'when multiple payments' do
      context 'when credit card and bank slip' do
        before { subject.payments = [card, bank_slip] }

        it 'returns credit_card' do
          expect(subject.price_method).to eq 'credit_card'
        end
      end

      context 'when credit cards only' do
        before { subject.payments = [card, card] }

        it 'returns credit_card' do
          expect(subject.price_method).to eq 'credit_card'
        end
      end

      context 'when bank slips only' do
        before { subject.payments = [bank_slip, bank_slip] }

        it 'returns bank_slip' do
          expect(subject.price_method).to eq 'bank_slip'
        end
      end
    end
  end

  describe '#checkout_method' do
    let(:card) { build(:payment, :card) }
    let(:card2) { build(:payment, :card) }
    let(:bank_slip) { build(:payment, :bank_slip) }
    let(:bank_slip2) { build(:payment, :bank_slip) }

    context 'when no payment is defined' do
      context 'when DEPRECATED checkout_method is present' do
        before { subject.checkout_method = 'credit_card' }

        it 'returns credit_card' do
          expect(subject.checkout_method).to eq 'credit_card'
        end
      end
    end

    context 'when one payment' do
      before do
        subject.payments = [bank_slip]
      end

      it 'returns the payment method itself' do
        expect(subject.checkout_method).to eq 'bank_slip'
      end
    end

    context 'when multiple payments' do
      context 'when credit card and bank slip' do
        before { subject.payments = [card, bank_slip] }

        it { expect(subject.checkout_method).to eq 'multiple' }
      end

      context 'when credit cards only' do
        before { subject.payments = [card, card2] }

        it { expect(subject.checkout_method).to eq 'multiple' }
      end

      context 'when bank slips only' do
        before { subject.payments = [bank_slip, bank_slip2] }

        it { expect(subject.checkout_method).to eq 'multiple' }
      end
    end
  end

  describe '#all_cards_authorized?' do
    let!(:order) { create(:order_valid) }
    let!(:card1) { create(:payment, :card, order: order) }
    let!(:card2) { create(:payment, :card, order: order) }
    let!(:bank_slip) { create(:payment, :bank_slip, order: order) }

    subject { order }

    context 'when there are no cards in the order' do
      before { ::OrderPayment.delete_all }

      it 'returns true' do
        expect(subject.collectable?).to be_truthy
      end
    end

    context 'when all cards are authorized' do
      before do
        card1.state_machine.transition_to!(:authorizing)
        card2.state_machine.transition_to!(:authorizing)
        card1.state_machine.transition_to!(:authorized)
        card2.state_machine.transition_to!(:authorized)
      end

      it 'returns true' do
        expect(subject.collectable?).to be_truthy
      end
    end

    context 'when not all cards are authorized' do
      before do
        card1.state_machine.transition_to!(:authorizing)
        card2.state_machine.transition_to!(:authorizing)
        card1.state_machine.transition_to!(:authorized)
      end

      it 'returns false' do
        expect(subject.collectable?).to be_falsey
      end
    end
  end

  describe '#all_paid?' do
    let!(:order) { create(:order_valid) }
    let!(:card1) { create(:payment, :card, order: order) }
    let!(:card2) { create(:payment, :card, order: order) }
    let!(:bank_slip) { create(:payment, :bank_slip, order: order) }

    subject { order }

    context 'when there are no cards in the order' do
      before { ::OrderPayment.delete_all }

      it 'returns true' do
        expect(subject.all_paid?).to be_truthy
      end
    end

    context 'when all cards are captured' do
      before do
        card1.state_machine.transition_to!(:captured)
        card2.state_machine.transition_to!(:captured)
      end

      it 'returns true' do
        expect(subject.all_paid?).to be_truthy
      end
    end

    context 'when not all cards are captured' do
      before do
        card1.state_machine.transition_to!(:authorizing)
        card1.state_machine.transition_to!(:authorized)
        card2.state_machine.transition_to!(:captured)
      end

      it 'returns false' do
        expect(subject.all_paid?).to be_falsey
      end
    end
  end

  describe '#has_all_bank_slips_paid?' do
    let!(:order) { create(:order_valid) }
    let!(:card1) { create(:payment, :card, order: order) }
    let!(:bank_slip1) { create(:payment, :bank_slip, order: order) }
    let!(:bank_slip2) { create(:payment, :bank_slip, order: order) }

    subject { order }

    context 'when there are no bank slips in the order' do
      before { ::OrderPayment.delete_all }

      it 'returns true' do
        expect(subject.all_bank_slips_paid?).to be_truthy
      end
    end

    context 'when all bank slips are paid' do
      before do
        bank_slip1.state_machine.transition_to!(:paid)
        bank_slip2.state_machine.transition_to!(:paid)
      end

      it 'returns true' do
        expect(subject.all_bank_slips_paid?).to be_truthy
      end
    end

    context 'when not all bank slips are paid' do
      before do
        bank_slip1.state_machine.transition_to!(:paid)
      end

      it 'returns false' do
        expect(subject.all_bank_slips_paid?).to be_falsey
      end
    end
  end

  describe '#installments' do
    let!(:order) { build(:order_valid, installments: 10) }
    context 'when try create order with installments invalid' do
      before { order.package.update(max_payments: 6) }

      it 'returns error' do
        expect do
          order.save!
        end.to raise_error(
          ActiveRecord::RecordInvalid,
          'A validação falhou: Installments O número de parcelas informado'\
          ' é inválido'
        )
      end
    end
  end

  describe '#refundable?' do
    context 'order is paid' do
      context 'iugu_order' do
        let!(:iugu_order) do
          create(:order_valid, :paid, broker: 'iugu')
        end
        it 'should be true' do
          expect(iugu_order.refundable?).to be_truthy
        end
      end

      context 'pagarme_order' do
        let!(:pagarme_order) do
          create(:order_valid, :paid, broker: 'pagarme')
        end
        it 'should be true' do
          expect(pagarme_order.refundable?).to be_truthy
        end
      end

      context 'app_store_order' do
        let!(:app_store_order) do
          create(:in_app_order, :paid, broker: 'app_store')
        end
        it 'should be false' do
          expect(app_store_order.refundable?).to be_falsey
        end
      end

      context 'play_store_order' do
        let!(:first_play_store_order) do
          create(:in_app_order, :paid, broker: 'play_store')
        end
        context 'is the last order on its subscription' do
          it 'should be true' do
            expect(first_play_store_order.refundable?).to be_truthy
          end
        end
        context 'is not the last order on its subscription' do
          let!(:second_play_store_order) do
            create(:in_app_order, broker: 'play_store',
                                  user: first_play_store_order.user)
          end
          it 'should be false' do
            expect(first_play_store_order.refundable?).to be_falsey
          end
        end
      end
    end

    describe '#buzzlead_indication?' do
      context 'when utm is nil' do
        let!(:order) { create(:order_valid) }

        it 'returns false' do
          expect(order.buzzlead_indication?).to be_falsey
        end
      end

      context 'when utm_source is different' do
        let!(:order) { create(:order_valid, :with_utm_attributes) }

        it 'returns false' do
          expect(order.buzzlead_indication?).to be_falsey
        end
      end

      context 'when utm_source is equal to buzzlead' do
        let!(:order) { create(:order_valid, :with_utm_buzzlead) }

        it 'returns true' do
          expect(order.buzzlead_indication?).to be_truthy
        end
      end
    end

    context 'order has a status that is not paid' do
      let!(:invalid_order) do
        create(:order_valid)
      end

      it 'should return false' do
        expect(invalid_order.refundable?).to be_falsey
      end
    end
  end

  describe 'status verification functions' do
    context 'paid?' do
      context 'with a paid order' do
        let!(:paid_order) { create(:paid_order) }
        it 'should return true' do
          expect(paid_order.paid?).to be(true)
        end
      end
    end
    context 'refund?' do
      context 'with a refunded order' do
        let!(:refunded_order) { create(:refunded_order) }
        it 'should return true' do
          expect(refunded_order.refunded?).to be(true)
        end
      end
    end
  end
end
