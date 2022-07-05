# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendEmailBankSlipOverduedWorker do
  describe 'perform' do
    context 'with a paid order' do
      let(:order) { create(:order) }
      before do
        order.payments = [create(:payment, :bank_slip)]
        order.payments.last.pagarme_transaction = create(:pagarme_transaction)
        order.payments.last.state_machine.transition_to(:paid)
      end
      it 'do not send any email' do
        expect do
          subject.perform(order.id)
        end.to change(ActionMailer::Base.deliveries, :count).by(0)
      end
    end
    context 'with a pending order' do
      let(:order) { create(:order) }
      before do
        order.payments = [create(:payment, :bank_slip)]
        order.payments.last.pagarme_transaction = create(:pagarme_transaction)
      end
      it 'send an email with bank slip overdued information from and to correct emails' do
        expect do
          subject.perform(order.id)
        end.to change(ActionMailer::Base.deliveries, :count).by(1)
        expect(ActionMailer::Base.deliveries.last.to.first).to eq(order.email)
        expect(ActionMailer::Base.deliveries.last.from.first).to eq("pagamentos@mesalva.com")
      end
    end
  end
end
