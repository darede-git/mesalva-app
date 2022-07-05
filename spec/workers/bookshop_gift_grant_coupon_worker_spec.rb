# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookshopGiftGrantCouponWorker do
  context 'perform' do
    let!(:bookshop_gift_package) { create(:bookshop_gift_package) }
    let!(:bookshop_gift_pending_ready_to_be_granted) do
      create(:bookshop_gift, :to_be_available, :with_order)
    end
    let!(:bookshop_gift_not_ready_to_be_granted) do
      create(:bookshop_gift, :with_order,
             avaliable_notified_at: Date.today,
             pending_notified_at: Date.today)
    end

    it 'makes eligible bookshop gifts available' do
      expect { subject.perform }.to change(Notification, :count).by(1)

      bookshop_gift_pending_ready_to_be_granted.reload
      expect(bookshop_gift_pending_ready_to_be_granted.coupon_available)
        .to be_truthy
    end
  end
end
