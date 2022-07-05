# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CrmRdstationUnsubscriberEventWorker do
  describe '#unsubscribe' do
    let!(:subscription) { create(:subscription) }

    before do
      subs = double
      expect(MeSalva::Crm::Rdstation::Event::Subscription).to receive(:new)
        .with({ subscription: subscription }).and_return(subs)
      expect(subs).to receive(:unsubscribe)
    end

    it 'creates a rdstation subscription_unsubscribe event' do
      subject.perform(subscription.id)
    end
  end
end
