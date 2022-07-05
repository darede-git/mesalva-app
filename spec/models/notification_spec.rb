# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  context 'validations' do
    it {
      should validate_inclusion_of(:notification_type)
        .in_array(%w[essay_draft_created_but_not_sent
                     bookshop_coupon_pending
                     bookshop_coupon_available
                     back_to_classes_campaign])
    }
  end

  context 'scope' do
    let!(:notification) do
      create(:notification, user_id: user.id)
    end
    context 'by_id' do
      it 'returns the notification with id of user' do
        expect(Notification.by_id(user, notification.id))
          .to include(notification)
      end
    end
    context 'by_user' do
      let!(:expired_notification) do
        create(:notification, :expired, user_id: user.id)
      end

      it 'returns not expired notifications of user' do
        expect(Notification.by_user(user)).to include(notification)
      end
    end
    context 'all_by_user' do
      let!(:expired_notification) do
        create(:notification, :expired, user_id: user.id)
      end

      it 'returns all notifications of user' do
        expect(Notification.all_by_user(user)).to include(notification)
        expect(Notification.all_by_user(user)).to include(expired_notification)
      end
    end
  end
end
