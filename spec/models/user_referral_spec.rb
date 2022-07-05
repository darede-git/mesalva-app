# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserReferral, type: :model do
  context 'validations' do
    it { should belong_to(:user) }
    it { should validate_presence_of(:user_id) }
  end

  context 'scopes' do
    context 'processed' do
      let!(:referral_processed) { create(:user_referral) }
      let!(:referral_not_processed) do
        create(:user_referral, being_processed: true)
      end
      it 'should only return referrals that have already been processed' do
        expect(UserReferral.processed).to include(referral_processed)
        expect(UserReferral.processed).not_to include(referral_not_processed)
      end
    end
  end
end
