# frozen_string_literal: true

class BookshopGiftPackage < ActiveRecord::Base
  belongs_to :package
  has_many :bookshop_gifts

  validates :active, acceptance: true

  def self.available_coupons_by_package
    select('bookshop_gift_packages.id,
           count(bookshop_gift_package_id) as available_coupons,
           bookshop_link, slug as package_slug, name as package_name, package_id,
           need_coupon').joins(:package, 'LEFT JOIN bookshop_gifts ON
                    bookshop_gifts.bookshop_gift_package_id = bookshop_gift_packages.id
                    AND bookshop_gifts.order_id IS NULL').group('bookshop_gift_packages.id,
                            bookshop_link, slug, name, package_id, bookshop_gift_package_id,
                            need_coupon').order('bookshop_gift_packages.id')
  end

  def self.active
    where(active: true)
  end
end
