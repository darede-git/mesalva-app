# frozen_string_literal: true

class Access < ActiveRecord::Base
  include IntercomHelper
  include TextSearchHelper
  include AlgoliaSearch
  include RdStationHelper

  SUBSCRIPTION_ADDITIONAL_TIME = 3.days.freeze

  after_create :send_rd_client_event, if: :send_crm_event?
  after_create :send_facebook_ads_event, if: :send_crm_event?
  after_create :user_intercom_subscriber, :add_essay_credits, :add_private_class_credits

  validates :user_id,
            :package_id,
            :starts_at,
            :expires_at,
            presence: true

  validates :active, inclusion: { in: [true, false] }

  belongs_to :user
  belongs_to :package
  belongs_to :order

  has_many :features, through: :package


  has_one :voucher

  scope :active, -> { where active: true }
  scope :inactive, -> { where active: false }
  scope :in_range, lambda {
    where('? BETWEEN accesses.starts_at AND accesses.expires_at', Time.now)
  }
  scope :by_user, ->(user) { where user: user }
  scope :by_platform, ->(platform) { where platform_id: platform.id }
  scope :by_package, ->(package) { where package: package }

  scope :with_package, lambda {
    select('accesses.*, packages.id package_id, packages.name package_name, packages.slug package_slug')
      .joins(:package)
  }

  scope :valid, lambda { |user, package|
    by_user(user)
      .by_package(package)
      .active
      .in_range
  }

  scope :expires_today, lambda {
    where('accesses.expires_at >= ? AND accesses.expires_at <= ?',
          Time.now.beginning_of_day, Time.now.end_of_day)
  }

  scope :by_user_active_in_range, ->(user) { by_user(user).active.in_range }

  scope :paid_access_by_user_and_packages, lambda { |user, packages|
    by_user(user)
      .where(package_id: packages)
      .where(gift: false)
      .active
      .in_range
  }

  scope :user_active_accesses_order_by_expiring_date, lambda { |user|
    by_user(user).active.in_range.order(:expires_at)
  }
  scope :user_accesses_order_by_expiring_date, lambda { |user|
    by_user(user).order(:expires_at)
  }

  scope :last_before_purchase, lambda { |user_id|
    where(user_id: user_id)
      .where("to_char(starts_at, 'YYYY-MM-DD') != :starts_at", starts_at: Date.today)
      .order(:expires_at)
  }

  scope :active_and_expiring_today, lambda {
    active.expires_today
  }

  algoliasearch index_name: name.pluralize, disable_indexing: Rails.env.test? do
    attribute :starts_at, :expires_at, :active, :created_at, :gift, :created_by
    attributesForFaceting %w[uid]

    attribute :uid do
      user.uid
    end

    attribute :package_slug do
      package.slug
    end
  end

  def unique?
    user.accesses.active.in_range.reject { |user_access| user_access == self }.count <= 0
  end

  def active_account?
    active
  end

  def full_remaining_days
    expires_at.to_date - Date.today
  end

  def inactive_account?
    !active
  end

  def about_to_expire?
    Date.today <= expires_at && Date.today >= expires_at - 30.days
  end

  def not_about_to_expire?
    Date.today <= expires_at && Date.today < expires_at - 30.days
  end

  def deactivate
    update(active: false)
  end

  def freeze
    user.state_machine.transition_to(:unsubscriber) if unique?
    update(active: false,
           remaining_days: ((expires_at - Time.now.utc) / 1.day) + 1)
  end

  def unfreeze
    user.state_machine.transition_to(:subscriber)
    update(active: true,
           expires_at: Time.now.utc + remaining_days.days,
           remaining_days: 0)
  end

  def user_intercom_subscriber
    update_intercom_user(user, subscriber: User::PREMIUM_STATUS[:subscriber],
                               plan: package_attribute('name'),
                               courses: package_attribute('label'),
                               vencimento_assinatura: first_expiration_date,
                               ultima_compra: last_order_date,
                               ultima_liberacao_acesso: created_at)
  end

  def send_rd_client_event
    send_rd_station_checkout_event(:purchase_event, user, package)
  end

  def send_facebook_ads_event
    MeSalva::Crm::Facebook.new.send_purchase_event(order)
  rescue StandardError
    nil
  end

  def add_essay_credits
    update(essay_credits: package.essay_credits)
  end

  def add_private_class_credits
    update(private_class_credits: package.private_class_credits)
  end

  def last_order_date
    return order.created_at if order
  end

  def first_expiration_date
    active_in_range.pluck(:expires_at).min
  end

  def active_in_range
    Access.by_user_active_in_range(user)
  end

  def actives_package_slug
    actives = active_in_range - [self]
    actives = actives.map(&:package).map(&:name)
    actives&.join('/')
  end

  def package_attribute(attribute)
    package_attribute = active_in_range.map(&:package).map(&attribute.to_sym)
    package_attribute&.join('/')
  end

  def duration_in_months
    package.duration_in_months
  end

  def package_subscription?
    package.subscription
  end

  def order_subscription_status
    order.subscription_active
  end

  def order_subscription
    order.try(:subscription)
  end

  def order_id
    order&.token
  end

  def send_crm_event?
    order_id && !Rails.env.test?
  end
end
