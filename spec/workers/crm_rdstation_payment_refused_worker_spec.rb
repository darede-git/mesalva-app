# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CrmRdstationPaymentRefusedWorker do
  describe '#perform' do
    let!(:order) { create(:order) }

    before do
      event_payment = double
      expect(MeSalva::Crm::Rdstation::Event::Payment).to receive(:new)
        .with({ order: order }).and_return(event_payment)
      expect(event_payment).to receive(:refused)
    end

    it 'creates a rdstation payment_refused event' do
      subject.perform(order.id)
    end
  end
end
