# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SendConfirmationWorker do
  context 'perform' do
    it 'send a email to user mail' do
      expect do
        subject.perform(token: user.token, client_config: '', redirect_url: '')
      end.to change(ActionMailer::Base.deliveries, :count).by(1)
      expect(ActionMailer::Base.deliveries.last.to.first).to eq(user.email)
    end
  end
end
