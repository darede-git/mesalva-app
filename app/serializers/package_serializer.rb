# frozen_string_literal: true

class PackageSerializer < ActiveModel::Serializer
  has_many :prices
  has_many :features

  attributes :name, :slug, :max_payments, :node_ids, :education_segment_slug,
             :subscription, :description, :sales_platforms, :info, :form, :pagarme_plan_id,
             :position, :active, :app_store_product_id, :play_store_product_id,
             :label, :essay_credits, :unlimited_essay_credits, :options, :package_type, :sku,
             :bookshop_gift_packages, :complementary, :complementary_packages, :bookshop_gift_stats

  def complementary_packages
    ComplementaryPackage.parsed_from_parent_id(object.id)
  end

  def bookshop_gift_stats
    bookshop_gift_stats = []
    object.bookshop_gift_packages.each do |bookshop_gift_package|
      bookshop_gift_stats << bookshop_gift_params(bookshop_gift_package)
    end
    bookshop_gift_stats
  end

  def bookshop_gift_params(bookshop_gift_package)
    { used: bookshop_gift_package.bookshop_gifts.coupon_available.count,
      unused: bookshop_gift_package.bookshop_gifts.never_used.count }
  end
end
