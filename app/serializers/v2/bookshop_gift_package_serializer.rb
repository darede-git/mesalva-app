# frozen_string_literal: true

class V2::BookshopGiftPackageSerializer
  include FastJsonapi::ObjectSerializer
  attributes :bookshop_link, :package_id

  attributes :available_coupons,
             :need_coupon,
             :package_slug,
             :need_coupon,
             :package_name, if: proc { |_object, params|
                                  params[:include_joined]
                                }
  def available_coupons
    object['available_coupons']
  end
end
