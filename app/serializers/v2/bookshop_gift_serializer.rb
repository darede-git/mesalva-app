# frozen_string_literal: true

class V2::BookshopGiftSerializer
  include FastJsonapi::ObjectSerializer
  has_one :bookshop_gift_package,
          serializer: ::V2::BookshopGiftPackageSerializer
  attribute :coupon
end
