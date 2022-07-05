# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserReferralCounterWorker do
  context '#perform' do
    let!(:user_referral) { create(:user_referral) }
    let!(:crm_event) { create(:crm_event, event_name: 'sign_up') }
    before do
      create(:utm,
             :desafio_me_salva,
             id: 13_600_001,
             referenceable_id: crm_event.id,
             utm_content: user_referral.user_token)
    end
    it 'returns the count of utm content referrals of the user' do
      subject.perform(user_referral.user_token)

      user_referral.reload
      expect(user_referral.confirmed_referrals).to eq(1)
    end
  end
end
