# frozen_string_literal: true

describe MeSalva::Payment::Pagarme::Charge do
  let(:order) { create(:order_with_address_attributes) }
  let!(:card) do
    create(:payment, :card, order: order,
                            card_token: 'card_ckljewknk0iyn0i9t63o9h49m')
  end
  let!(:bank_slip) { create(:payment, :bank_slip, order: order) }
  subject { described_class.new(card, 'custom billing name') }

  describe '#capture' do
    context 'with order by card in 1x' do
      it 'creates a card charging' do |example|
        VCR.use_cassette(test_name(example)) do
          response = subject.perform

          expect(response.status).to eq('processing')
          expect(response.payment_method).to eq('credit_card')
          expect(response.installments).to eq(card.installments)
          expect(response.card_last_digits).to eq('1111')
          expect(response.paid_amount).to eq(0)
        end
      end
    end

    context 'with order by card in 10x' do
      before { card.update(installments: 10) }
      it 'creates a card charging' do |example|
        VCR.use_cassette(test_name(example)) do
          response = subject.perform

          expect(response.status).to eq('processing')
          expect(response.installments).to eq(card.installments)
          expect(response.paid_amount).to eq(0)
        end
      end
    end
  end

  describe '#authorize' do
    context 'with order by card' do
      it 'authorize with paid amount equals zero' do |example|
        VCR.use_cassette(test_name(example)) do
          response = subject.perform(true)

          expect(response.status).to eq('processing')
          expect(response.payment_method).to eq('credit_card')
          expect(response.installments).to eq(1)
          expect(response.card_last_digits).to eq('1111')
          expect(response.paid_amount).to eq(0)
        end
      end
    end
  end
end
