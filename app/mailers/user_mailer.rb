# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def email_changed(id, platform_slug = nil)
    @platform = Platform.find_by_slug(platform_slug)
    @user = if @platform.nil?
              User.find(id)
            else
              UserPlatform.where(user_id: id, platform_id: @platform.id).take.user
            end

    send_mail
  end

  private

  def send_mail
    @user.update(options: { 'new-email': "new-#{@user.email}" }) if Rails.env.test?

    mail to: @user.options['new-email'], from: sender,
         subject: "Confirme seu novo e-mail na paltaforma #{@platform.try(:name) || 'Me Salva!'}"
  end
end
