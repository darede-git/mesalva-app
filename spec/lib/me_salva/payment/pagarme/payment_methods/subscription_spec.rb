# frozen_string_literal: true

describe MeSalva::Payment::Pagarme::Charge do
  let(:order) { create(:order_with_address_attributes) }

  describe '#perform' do
    before do
      order.package.update(subscription: true, pagarme_plan_id: 171_152)
    end
    subject { described_class.new(card, 'custom billing name') }
    context 'with subscription by card' do
      let(:card) do
        create(:payment, :card, order: order,
                                card_token: 'card_ckljewknk0iyn0i9t63o9h49m')
      end
      it 'creates a subscription charging' do |example|
        VCR.use_cassette(test_name(example)) do
          order.update checkout_method: :credit_card
          response = subject.perform

          assert_subscription_charge(response, 'paid', 'credit_card')
          expect(response.current_transaction.card_last_digits).to eq('1111')
          expect(response.current_transaction.paid_amount).to eq(4990)
        end
      end
    end

    context 'with subscription by bank slip' do
      let!(:bank_slip) { create(:payment, :bank_slip, order: order) }
      subject { described_class.new(bank_slip, 'custom billing name') }
      it 'creates a subscription charging' do |example|
        VCR.use_cassette(test_name(example)) do
          response = subject.perform

          assert_subscription_charge(response, 'waiting_payment', 'boleto')
          expect(response.current_transaction.boleto_url).not_to be_nil
          expect(response.current_transaction.boleto_barcode).not_to be_nil
        end
      end
    end
  end

  def assert_subscription_charge(response, status, method)
    expect(response.object).to eq('subscription')
    expect(response.current_transaction.status).to eq(status)
    expect(response.current_transaction.payment_method).to eq(method)
  end
end
