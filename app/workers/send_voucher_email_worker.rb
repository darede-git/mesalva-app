# frozen_string_literal: true

class SendVoucherEmailWorker
  include Sidekiq::Worker

  def perform(token)
    voucher = PlatformVoucher.find_by_token(token)
    platform_slug = voucher.platform.slug
    return unless platform_slug

    PlatformMailer.platform_voucher_alert(voucher.email, platform_slug, voucher).deliver
  end
end
