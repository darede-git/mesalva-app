# frozen_string_literal: true

describe MeSalva::Payment::Pagarme::PaymentMethods::Charge do
  let(:order) { create(:order_with_address_attributes) }
  let!(:bank_slip) { create(:payment, :bank_slip, order: order) }
  subject { described_class.new(bank_slip, 'custom billing name') }

  describe '#perform' do
    describe 'with order by bank slip' do
      it 'creates a bank slip charging' do |example|
        VCR.use_cassette(test_name(example)) do
          response = subject.perform

          expect(response.status).to eq('waiting_payment')
          expect(response.payment_method).to eq('boleto')
          expect(response.installments).to eq(1)
          expect(response.boleto_barcode).not_to be_nil
          expect(response.boleto_url).not_to be_nil
          expect(response.amount).to eq(bank_slip.amount_in_cents)
        end
      end
    end
  end
end
