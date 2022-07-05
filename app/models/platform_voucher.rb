# frozen_string_literal: true

class PlatformVoucher < ActiveRecord::Base
  belongs_to :platform
  belongs_to :user
  belongs_to :package
  has_secure_token

  before_destroy :throw_consumed_abort, if: :user_id?
  before_update :throw_consumed_abort, if: :already_consumed?

  validates :package_id, :platform_id, presence: true

  scope :email_eq, ->(email) { where(email_filter(email)) }
  scope :duration_eq, ->(duration) { where(duration_filter(duration)) }
  scope :vouchers_by_package, ->(package_slug) { where(package_filter(package_slug)) }
  scope :vouchers_by_platform, ->(platform_slug) { where(platform_filter(platform_slug)) }

  def first_name
    name = options['nome'] || options['nome_completo']
    return nil if name.nil?

    name.gsub(/ .*/, '')
  end

  private

  def already_consumed?
    return true if user_id?
    return true unless changes[:user_id]&.first.nil?
  end

  def self.platform_filter(slug)
    platform = Platform.find_by_slug(slug)
    return nil unless platform

    ActiveRecord::Base.sanitize_sql_array(["platform_vouchers.platform_id = ?", platform&.id])
  end

  def self.email_filter(email)
    return nil unless email

    ActiveRecord::Base.sanitize_sql_array(["platform_vouchers.email = ?", email.to_s])
  end

  def self.duration_filter(duration)
    return nil unless duration

    ActiveRecord::Base.sanitize_sql_array(["platform_vouchers.duration = ?", duration.to_i])
  end

  def self.package_filter(package_slug)
    return nil unless package_slug

    package = Package.find_by_slug(package_slug)

    ActiveRecord::Base.sanitize_sql_array(["platform_vouchers.package_id = ?", package&.id])
  end

  def throw_consumed_abort
    errors.add(:base, I18n.t("activerecord.errors.messages.voucher_already_consumed"))
    throw(:abort)
  end
end
