# frozen_string_literal: true

class ComplementaryPackage < ActiveRecord::Base
  has_many :package
  belongs_to :order

  scope :existing, lambda { |package, child_package|
    where(package_id: package.id, child_package_id: child_package.id).count.positive?
  }

  scope :get_complementary_package, lambda { |package|
    where(package_id: package.id)
  }

  scope :parsed_from_parent_id, lambda { |package_id|
    packages = []
    select("packages.id, packages.name, packages.slug, prices.price_type, prices.value")
      .joins("INNER JOIN packages ON packages.id = complementary_packages.child_package_id")
      .joins("INNER JOIN prices ON prices.package_id = complementary_packages.child_package_id")
      .where(package_id: package_id).order(:position).each do |pack|
      parsed_pack = packages.find { |p| p[:slug] == pack.slug }
      if parsed_pack
        parsed_pack[:prices][pack.price_type] = pack.value.to_f
        next
      end
      prices = {}
      prices[pack.price_type] = pack.value.to_f
      packages << {
        id: pack.id,
        name: pack.name,
        slug: pack.slug,
        prices: prices
      }
    end
    packages
  }

  def self.sum_complementary_packages_prices(complementary_package_ids, checkout_method)
    if complementary_package_ids.present?
      total_price = 0
      complementary_package_ids.each do |complementary_package_id|
        total_price += Price.by_package_and_price_type(complementary_package_id,
                                                       checkout_method)
                            .value
                            .to_f
      end
      total_price.to_f
    else
      0
    end
  end
end
