# frozen_string_literal: true

class BookshopGift < ActiveRecord::Base
  belongs_to :order
  belongs_to :bookshop_gift_package

  def self.take_coupon(package_id)
    coupon = joins(:bookshop_gift_package)
             .where("bookshop_gift_packages.package_id = ?", package_id)
             .never_used

    return coupon.first unless coupon.nil?
  end

  scope :without_order, -> { where(order_id: nil) }

  scope :coupon_available, -> { where(coupon_available: true) }

  scope :never_used, -> { where(coupon_available: false).without_order }

  scope :by_user, lambda { |user|
    joins(:order).where("orders.user_id = #{user.id}")
  }
end
