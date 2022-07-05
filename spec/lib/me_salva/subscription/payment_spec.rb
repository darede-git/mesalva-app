# frozen_string_literal: true

require 'me_salva/subscription/payment'

RSpec.shared_examples 'a renew payment' do |transaction_class|
  let(:transaction_method) { transaction_class.name.underscore }
  let(:subject) do
    described_class.new(
      payment,
      transaction_method,
      payment_attributes: custom_attributes,
      transaction_attributes: transaction_attributes
    ).renew
  end

  it 'returns a new payment attributes' do
    expect(subject.class).to eq(OrderPayment)
    expect(subject.id).to be_nil
    expect(subject.payment_method).to eq(payment_method)
    expect(subject.order_id).to be_nil
    expect(subject.installments).to eq(1)
    expect(subject.public_send(transaction_method).transaction_id)
      .to eq(transaction_id)
  end
end

describe MeSalva::Subscription::Payment do
  let(:transaction_id) { '12345678890' }
  let(:transaction_attributes) { { transaction_id: transaction_id } }

  let(:payment_method) { 'card' }

  describe '#renew' do
    context 'with custom attributes' do
      let(:custom_attributes) { { payment_method: payment_method } }

      context 'pagarme payment' do
        let(:payment) do
          create(:payment, :with_pagarme_transaction)
        end

        it_behaves_like 'a renew payment', PagarmeTransaction
      end

      context 'play store payment' do
        let(:payment) do
          create(:payment, :with_play_store_transaction)
        end

        it_behaves_like 'a renew payment', PlayStoreTransaction
      end

      context 'app store payment' do
        let(:payment) do
          create(:payment, :with_app_store_transaction)
        end

        it_behaves_like 'a renew payment', AppStoreTransaction
      end
    end

    context 'without custom attributes' do
      let(:custom_attributes) { nil }
      let(:payment) { create(:payment, :with_pagarme_transaction) }

      it_behaves_like 'a renew payment', PagarmeTransaction
    end
  end
end
