# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostBuyNotificationCampaign, type: :model do
  context 'validations' do
    it { should validate_presence_of(:package_ids) }
    it { should validate_presence_of(:notification_type) }
  end
  context 'scope' do
    let(:first_package) { create(:package_valid_with_price) }

    before do
      create(:order,
             created_at: Time.now,
             package_id: first_package.id)
      create(:post_buy_notification_campaign,
             package_ids: [first_package.id])
    end

    context 'active' do
      it 'returns only active campaigns' do
        create(:post_buy_notification_campaign,
               active: false,
               package_ids: [first_package.id])
        expect(PostBuyNotificationCampaign.active.count).to eq(1)
      end
    end

    context 'in period' do
      it 'returns only campaigns active today' do
        expect(PostBuyNotificationCampaign.in_period.count).to eq(1)
      end
    end
  end
end
