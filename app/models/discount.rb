# frozen_string_literal: true

class Discount < ActiveRecord::Base
  include TokenHelper
  include TextSearchHelper
  include AlgoliaSearch

  ROUND_PRECISION = 2

  before_validation :generate_token, on: :create
  before_save :upcase_code

  has_many :orders
  belongs_to :user

  validates :packages, :percentual, :name, :starts_at,
            :expires_at, presence: true, allow_blank: false
  validates :token, :code, presence: true, uniqueness: true
  validates_numericality_of :percentual, greater_than: 0,
                                         less_than_or_equal_to: 100

  validate :upsell_packages_nil_or_with_element

  algoliasearch index_name: name.pluralize, disable_indexing: Rails.env.test? do
    attribute :id,
              :name,
              :description,
              :token,
              :percentual,
              :code,
              :user_id,
              :starts_at,
              :expires_at,
              :created_by,
              :updated_by,
              :packages,
              :only_customer,
              :upsell_packages
    attribute :starts_at_unix do
      starts_at.to_i
    end
    attribute :expires_at_unix do
      expires_at.to_i
    end
  end

  def deduct_discount(value)
    (value * percent).round(ROUND_PRECISION)
  end

  def percent
    percentual.to_f / 100
  end

  private

  def upcase_code
    code.try(:upcase!)
  end

  def upsell_packages_nil_or_with_element
    return if upsell_packages.nil? || !upsell_packages.empty?

    errors.add(:upsell_packages,
               "precisa ser nulo ou ter elementos")
  end
end
