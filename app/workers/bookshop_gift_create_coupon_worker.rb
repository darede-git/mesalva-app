# frozen_string_literal: true

class BookshopGiftCreateCouponWorker
  include Sidekiq::Worker

  def perform
    return unless ENV['BOOKSHOP_COUPONS_CAMPAING_ACTIVE'] == 'true'

    revert_gifts_with_refunded_orders
    create_pending_gift_coupons
  end

  private

  def revert_gifts_with_refunded_orders
    ActiveRecord::Base.connection.execute(
      <<~SQL
        WITH t AS (
          SELECT bookshop_gifts.order_id
          FROM bookshop_gifts
          INNER JOIN orders ON orders.id = bookshop_gifts.order_id
          WHERE orders.status = 6
          AND bookshop_gifts.order_id IS NOT NULL
        )
        UPDATE bookshop_gifts
        SET coupon_available = false
        FROM t
        WHERE bookshop_gifts.order_id = t.order_id
    SQL
    )
  end

  def create_pending_gift_coupons
    BookshopGiftPackage.active.each do |bookshop_gift_package|
      bookshop_gift_package.notified_at = Date.yesterday if bookshop_gift_package.notified_at.nil?

      begin
        reserve_coupons(bookshop_gift_package)
      rescue MeSalva::Error::BookshopGiftsRanOutError => exception
        NewRelic::Agent.notice_error(exception,
                                     response_body: exception.body,
                                     status_code: exception.status_code)
        next
      end
      bookshop_gift_package.notified_at = Time.now
      bookshop_gift_package.save
    end
  end

  def reserve_coupons(bookshop_gift_package)
    elligible_orders(bookshop_gift_package).each do |order|
      coupon = BookshopGift.take_coupon(order.package_id)
      coupon.order = order
      coupon.pending_notified_at = order.updated_at
      coupon.save

      notify_user(order.user_id)
    end
  end

  def notify_user(user_id)
    Notification.create(user_id: user_id, notification_type: "bookshop_coupon_pending")
  end

  def elligible_orders(bookshop_gift_package)
    limit = BookshopGift.never_used.where(bookshop_gift_package: bookshop_gift_package).count
    Order.paid
         .joins('LEFT JOIN bookshop_gifts ON bookshop_gifts.order_id = orders.id')
         .where(package_id: bookshop_gift_package.package_id)
         .where('bookshop_gifts.id IS NULL')
         .limit(limit)
  end

  def available_coupons(bookshop_gift_package_id)
    BookshopGift.without_order.where(bookshop_gift_package_id: bookshop_gift_package_id)
  end

  def pending_coupon_message
    I18n.t('book_shop_gift.notification.created_pending_coupon')
  end
end
