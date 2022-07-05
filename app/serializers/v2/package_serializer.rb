# frozen_string_literal: true

class V2::PackageSerializer < V2::ApplicationSerializer
  has_many :prices, if: proc { |_object, params|
    params[:simplified] != true
  }
  has_many :features, if: proc { |_object, params|
    params[:simplified] != true
  }
  has_many :complementary_packages, if: proc { |_object, params|
    params[:simplified] != true
  }

  attributes :id, :name, :slug, :max_payments, :education_segment_slug,
             :subscription, :description, :sales_platforms, :info, :form,
             :position, :active, :app_store_product_id, :play_store_product_id,
             :label, :essay_credits, :private_class_credits, :unlimited_essay_credits,
             :options, :duration, :color_hex, :image, :package_type, :sku, :complementary

  attribute :education_segment_name do |object|
    object.education_segment_name if object.respond_to?(:education_segment_name)
  end

  attribute :bookshop_link do |object|
    object.bookshop_link if object.respond_to?(:bookshop_link)
  end
end
