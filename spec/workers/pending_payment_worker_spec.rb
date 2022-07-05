# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PendingPaymentWorker do
  let!(:order) { create(:order_valid, created_at: Date.today - 9.days) }

  describe '#perform' do
    subject { described_class.new }

    context 'process a valid partial payment' do
      it 'should transition to pre_approved and send mail' do
        expect { subject.perform }.to change(ActionMailer::Base.deliveries, :count).by(1)
        expect(ActionMailer::Base.deliveries.last.subject).to eq(
          "Acesso liberado para pagamento parcial"
        )
        expect(order.reload.status).to eq(8)
      end
    end
  end
end
