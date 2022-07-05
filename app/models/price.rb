# frozen_string_literal: true

class Price < ActiveRecord::Base
  belongs_to :package

  PRICE_TYPES = %w[credit_card bank_slip pix app_store play_store whatsapp].freeze

  validates :value, presence: true
  validates :price_type, inclusion: { in: PRICE_TYPES }
  validates :currency, inclusion: { in: %w[BRL USD] }

  scope :active_ordered_by_id, lambda {
    where(active: true).order(:id)
  }

  def self.by_package_and_price_type(package_id, price_type)
    where(package_id: package_id, price_type: price_type).first
  end
end
