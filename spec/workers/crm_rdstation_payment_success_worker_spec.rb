# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CrmRdstationPaymentSuccessWorker do
  describe '#perform' do
    let!(:order) { create(:order) }

    before do
      event_payment = double
      expect(MeSalva::Crm::Rdstation::Event::Payment).to receive(:new)
        .with({ order: order }).and_return(event_payment)
      expect(event_payment).to receive(:success)
    end

    it 'creates a rdstation payment_success event' do
      subject.perform(order.id)
    end
  end
end
