# frozen_string_literal: true

class AddNeedCouponToBookshopGiftPackage < ActiveRecord::Migration[5.2]
  def change
    add_column :bookshop_gift_packages, :need_coupon, :boolean, default: false
  end
end
