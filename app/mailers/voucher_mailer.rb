# frozen_string_literal: true

class VoucherMailer < ApplicationMailer
  default from: "Me Salva! <#{ENV['MAIL_SENDER']}>"

  def invitation_email(order, coupon)
    @coupon = coupon
    @name = order.user.name

    email = order.email || order.user.email
    send_email(email, t('mailer.voucher.invitation.subject'))
  end

  def create_access_email(user)
    @name = user.name
    send_email(user.email, t('mailer.voucher.create_access.subject'))
  end

  def remove_access_email(user)
    @name = user.name
    send_email(user.email, t('mailer.voucher.remove_access.subject'))
  end

  private

  def send_email(email, subject)
    return if email.nil?

    mail(to: email, subject: subject)
  end
end
