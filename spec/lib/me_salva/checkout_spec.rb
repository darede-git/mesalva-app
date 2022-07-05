# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MeSalva::Checkout do
  let(:user) { build(:user) }
  let(:name) { 'my name' }
  let(:email) { 'my email' }
  let(:options) { {} }

  subject do
    described_class.new(
      order: order,
      user: user,
      name: name,
      email: email,
      options: options
    )
  end

  describe '#process' do
    context 'when is a subscription checkout' do
      let(:order) { build(:order_with_pagarme_subscription) }
      let(:current_transaction) { double('Transaction', id: '1') }
      let(:charge_response) do
        double('PagarmeResponse',
               status: 'paid', current_period_end: '2018-05-09T18:04:06.430Z',
               id: '1',        current_transaction: current_transaction)
      end

      before do
        order.payments = [
          create(:payment,
                 order: order, amount_in_cents: 1000,
                 payment_method: ::OrderPayment::Methods::CARD,
                 installments: 1, card_token: 'card_ckljewknk0iyn0i9t63o9h49m')
        ]
      end

      context 'with valid attributes' do
        it 'save invoice id on database' do
          allow(subject).to receive(:charge_payment)
            .with(order.payments.first)
            .and_return(charge_response)

          subject.process
        end
      end
    end

    context 'when is not a subscription checkout' do
      let(:order) do
        build(:order_valid, broker: 'pagarme')
      end
      let(:charge_response) do
        double('PagarmeResponse',
               boleto_url: 'http://pagarme.com',
               boleto_barcode: '12345678',
               id: '1')
      end
      before do
        order.payments = [
          create(:payment, payment_method: ::OrderPayment::Methods::CARD,
                           amount_in_cents: 400, installments: 1,
                           card_token: 'card_ckljewknk0iyn0i9t63o9h49m')
        ]
      end

      it 'save invoice id on database' do
        allow(subject).to receive(:charge_payment)
          .with(order.payments.first)
          .and_return(charge_response)

        subject.process
      end
    end
  end
end
