# frozen_string_literal: true

class Platform < ActiveRecord::Base
  include SlugHelper
  include TextSearchHelper
  before_validation :set_slug, on: :create, unless: :slug?
  before_validation :set_default_attributes

  has_many :platform_unities
  has_many :user_platforms
  has_many :users, through: :user_platforms
  validates :slug, presence: true

  scope :by_user, ->(user_id) { joins(:user_platforms).where("user_platforms.user_id": user_id) }

  scope :find_signin_user, -> (user_id, platform_slug) {
    platform = Platform.select('platforms.*, user_platforms.role')
                       .joins(:user_platforms)
                       .where({ "user_platforms.active": true,
                                "user_platforms.user_id": user_id,
                                "slug": platform_slug }).first
    return platform unless platform.nil?
    Platform.select('platforms.*, user_platforms.role')
            .joins(:user_platforms)
            .where({ "user_platforms.active": true,
                     "user_platforms.user_id": user_id,
                     "user_platforms.role": 'admin',
                     "slug": 'admin' }).first
  }

  validates :domain, presence: true

  validates :cnpj,
            format: { with: %r/\A[0-9]{2}\.[0-9]{3}\.[0-9]{3}\/[0-9]{4}-[0-9]{2}\z/,
                      message: I18n.t('errors.messages.invalid_cnpj') },
            allow_blank: true

  validates_uniqueness_of :cnpj

  def set_slug
    self.slug = "#{sanitized_column}-#{friendly_code}"
  end

  private

  def set_default_attributes
    self.dedicated_essay ||= false
    self.domain ||= 'mesalva.com'
  end

  def slug?
    return true unless slug.nil?
  end
end
