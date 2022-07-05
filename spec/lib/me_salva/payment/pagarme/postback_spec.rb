# frozen_string_literal: true

require 'me_salva/payment/pagarme/postback'

RSpec.shared_examples 'validate_transitions' do |params|
  params.each do |attributes|
    context 'validations' do
      context "receiving #{attributes.first} status" do
        subject { described_class.new(entity: card, status: attributes.first) }

        it "should be able to transit to #{attributes.first}" do
          expect(subject.process).to eq(attributes.last)
        end
      end
    end
  end
end

describe MeSalva::Payment::Pagarme::Postback do
  describe '#process' do
    context 'with pending payment' do
      let(:order) { create(:order_valid) }
      let!(:card) { create(:payment, :card, order: order) }
      it_should_behave_like 'validate_transitions', [['paid', true],
                                                     ['refused', true],
                                                     ['refunded', false]]
    end

    context 'subscription without address' do
      let!(:order) do
        create(:order, :credit_card, subscription: subscription,
                                     payments: [payment])
      end
      let(:payment) { create(:payment, :card, :with_pagarme_transaction) }
      let(:subscription) { create(:subscription) }
      let(:attributes) do
        { entity: subscription,
          status: 'paid',
          current_transaction_id: '123',
          next_recurrence_date: Time.now + 30.days,
          amount_paid: 1000,
          payment_method: 'card' }
      end
      subject { described_class.new(attributes) }

      it 'creates recurrence without address' do
        subject.process
        expect(Order.last.address).to eq(nil)
      end
    end
  end

  describe '#valid_signature' do
    it 'assert pagarme postback request is valid' do
      valid_postback_request
      expect(
        MeSalva::Payment::Pagarme::Postback.valid_signature?(@request)
      ).to be_truthy
    end
  end
end
