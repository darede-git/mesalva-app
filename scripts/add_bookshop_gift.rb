# frozen_string_literal: true

cupoms = ["XPT0$AC@", "R@ND0M"]

bs_gift_package_id = 9999
errors = []

cupoms.each do |cupom|
  bookshop_gift = BookshopGift.new(coupon: cupom, bookshop_gift_package_id: bs_gift_package_id)
  errors << cupom unless bookshop_gift.save
end

puts errors.inspect
