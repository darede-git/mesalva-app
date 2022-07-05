# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CrmRdstationSignupEventWorker do
  describe '#perform' do
    let!(:user) { create(:user) }
    let(:client) { 'WEB' }

    before do
      event_signup = double
      expect(MeSalva::Crm::Rdstation::Event::Login).to receive(:new)
        .with({ user: user, client: client }).and_return(event_signup)
      expect(event_signup).to receive(:sign_up)
    end

    it 'creates a rdstation login_signup event' do
      subject.perform(user.uid, client)
    end
  end
end
