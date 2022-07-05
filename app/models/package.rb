# frozen_string_literal: true

class Package < ActiveRecord::Base
  include SlugHelper
  include TextSearchHelper
  include AlgoliaSearch
  include CommonModelScopes

  SALES_PLATFORMS = %w[web ios android].freeze

  has_and_belongs_to_many :nodes
  has_many :orders
  has_many :prices, -> { active_ordered_by_id }, dependent: :destroy
  has_many :accesses
  has_many :package_features
  has_many :features, through: :package_features
  has_many :bookshop_gift_packages, validate: false
  has_many :complementary_packages

  belongs_to :tangible_product

  accepts_nested_attributes_for :prices
  accepts_nested_attributes_for :nodes
  accepts_nested_attributes_for :bookshop_gift_packages, reject_if: :all_blank, allow_destroy: true

  validates :prices, :node_ids, presence: true
  validate :only_duration_or_expires_at_is_present
  validate :unlimited_credits_or_regular_essay_credits
  validates :education_segment_slug,
            inclusion: { in: %w[enem-e-vestibulares ensino-medio concursos
                                ciencias-da-saude engenharia cursos-rapidos
                                plataforma-ms negocios ensino-fundamental-ii] }, presence: true

  validate :sales_platforms_names
  validate :validate_subscriptions_prices, if: :subscription
  validate :private_class_credits, :validate_private_class_credits

  scope :active, -> { where active: true }

  scope :ordered_by_position, -> { order(position: :asc) }

  scope :listed, lambda { |listed|
    where(listed: listed)
      .active.ordered_by_position
  }

  scope :full_filters, lambda { |filter_params|
    joins('LEFT JOIN nodes ON nodes.id = packages.education_segment_id OR nodes.slug = packages.education_segment_slug')
      .joins('LEFT JOIN bookshop_gift_packages ON bookshop_gift_packages.package_id = packages.id')
      .select('packages.*, nodes.name as education_segment_name, bookshop_gift_packages.bookshop_link')
      .filters(filter_params)
  }

  scope :by_education_segment_slug_and_platform,
        lambda { |education_segment_slug, platform|
          by_education_segment_slug(education_segment_slug)
            .by_platform(platform)
        }

  scope :by_education_segment_slug, lambda { |education_segment_slug|
    where(education_segment_slug: education_segment_slug).listed(true)
  }

  scope :by_platform, lambda { |platform|
    where('?=ANY(sales_platforms)', platform).listed(true)
  }

  def child_package_ids=(package_ids)
    ComplementaryPackage.where(package_id: id).delete_all
    package_ids.each_with_index do |child_package, index|
      ComplementaryPackage.create(package_id: id, position: index, child_package_id: child_package)
    end
  end

  def child_package_ids
    complementary_packages.pluck(:child_package_id)
  end

  def duration_in_months
    duration.months
  end

  def duration?
    !duration.nil?
  end

  def gateway_plan_price
    ::Price.find_by_package_id(id).value
  end

  def checkout_url
    "#{ENV['DEFAULT_URL']}/compra/#{slug}/cartao"
  end

  def child_packages2
    joins('INNER JOIN complementary_packages ON complementary_packages.package_id = packages.id').where({ "complementary_packages.package_id": self.id })
  end

  private

  def validate_subscriptions_prices
    return unless bank_slip_slug_and_card_price

    errors.add(:message, I18n.t('errors.messages.invalid_subscription_price'))
  end

  def bank_slip_slug_and_card_price
    slug =~ /boleto/ && include_card_price?
  end

  def include_card_price?
    prices.detect { |p| p.price_type == 'credit_card' }.present?
  end

  def only_duration_or_expires_at_is_present
    add_base_errors unless only_one_is_present
  end

  def unlimited_credits_or_regular_essay_credits
    return unless essay_credits.nil? ||
      essay_credits.negative? ||
      unlimited_essay_credits.nil?

    errors.add(
      :message,
      'Créditos de redação devem ser iguais ou maiores que zero ou ilimitados'
    )
  end

  def validate_private_class_credits
    return true unless private_class_credits.negative?

    errors.add(
      :message,
      'Créditos de aulas partivulares devem ser iguais ou maiores que zero'
    )
  end

  def add_base_errors
    errors.add(:base, 'Specify a duration or a expires_at, not both')
  end

  def only_one_is_present
    duration.blank? ^ expires_at.blank?
  end

  def sales_platforms_names
    self.sales_platforms = sales_platforms&.compact&.reject(&:empty?)
    if sales_platforms.nil? || sales_platforms.empty?
      return errors.add(:message,
                        'Plataforma de venda não pode ficar em branco')
    end
    sales_platforms.each do |platform|
      errors.add(:message, 'Plataforma de venda inválida') \
        unless valid_sale_platform?(platform)
    end
  end

  def valid_sale_platform?(platform)
    SALES_PLATFORMS.include? platform
  end

  algoliasearch index_name: name.pluralize, disable_indexing: Rails.env.test? do
    attribute :slug, :name,
              :duration, :iugu_plan_id,
              :iugu_plan_identifier, :subscription,
              :max_payments, :education_segment_slug,
              :description, :info,
              :listed, :form,
              :position, :expires_at,
              :active, :sales_platforms
    attribute :education_segment_name do
      Node.find_by_slug(education_segment_slug).name
    end
    attribute :access_to do
      nodes.pluck(:id, :name)
    end
    attribute :prices do
      prices.map { |p| [p.id, p.price_type, p.value.to_f, p.active] }
    end
  end
end
