# frozen_string_literal: true

class BookshopGiftGrantCouponWorker
  include Sidekiq::Worker

  def perform
    return unless ENV['BOOKSHOP_COUPONS_CAMPAING_ACTIVE'] == 'true'

    make_coupons_available
  end

  private

  def make_coupons_available
    pending_coupons_eligible_to_be_available.each do |bookshop_gift|
      bookshop_gift.coupon_available = true
      bookshop_gift.avaliable_notified_at = DateTime.now
      bookshop_gift.save

      Notification.create(
        user_id: bookshop_gift.order.user_id,
        notification_type: "bookshop_coupon_available"
      )
    end
  end

  def pending_coupons_eligible_to_be_available
    BookshopGift.joins(:bookshop_gift_package)
                .where("bookshop_gift_packages.active IS true")
                .where("coupon_available IS false")
                .where("order_id IS NOT NULL")
                .where("bookshop_gifts.avaliable_notified_at IS NULL")
                .where("bookshop_gifts.pending_notified_at <= ?", Date.today)
  end
end
