# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreateIntercomEventWorker do
  let!(:user) { create(:user) }
  let!(:valid_attributes) do
    ['checkout_submit_bank_slip', user.uid,
     { 'user_id' => user.uid,
       'user_email' => user.email,
       'user_premium' => 'false',
       'order_payment_type' => 'bank_slip',
       'timestamp' => '2016-09-30 10:24:26 -0300' }]
  end

  describe '#perform' do
    it 'creates a intercom event' do
      client = double(create: true)
      allow(MeSalva::Crm::Events).to receive(:new) { client }

      expect(client)
        .to receive(:create)
        .with('checkout_submit_bank_slip', user.uid, Time.at(1_475_242_445),
              'user_id' => user.uid, 'user_email' => user.email,
              'user_premium' => 'false', 'order_payment_type' => 'bank_slip',
              'timestamp' => '2016-09-30 10:24:26 -0300')
      subject.perform(valid_attributes)
    end
  end
end
