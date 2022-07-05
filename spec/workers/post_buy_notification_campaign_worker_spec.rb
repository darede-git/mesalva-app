# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostBuyNotificationCampaignWorker do
  describe '#perform' do
    context 'with campaign in period' do
      let(:second_user) { create(:user) }

      let(:first_package) { create(:package_valid_with_price) }
      let(:second_package) { create(:package_valid_with_price) }
      before do
        create(:order,
               :paid,
               created_at: Time.now,
               package_id: first_package.id)
        create(:order,
               :paid,
               created_at: Time.now,
               package_id: first_package.id,
               user_id: second_user.id)
        create(:post_buy_notification_campaign,
               package_ids: [first_package.id, second_package.id])
      end

      it 'creates a notification for the user' do
        expect { subject.perform }.to change(Notification, :count).by(2)
      end
    end

    context 'with no campaign in period' do
      it 'raises no error' do
        expect { subject.perform }.not_to raise_error
      end
    end
  end
end
