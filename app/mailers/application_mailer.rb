# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "Me Salva! <#{ENV['MAIL_SENDER']}>"

  def sender
    return "Me Salva! <#{ENV['MAIL_SENDER']}>" if @platform.nil?

    "#{@platform.name} - Plataforma MS <#{ENV['MAIL_SENDER']}>"
  end

  def set_platform(platform_slug = nil)
    return nil if platform_slug.nil?
    @platform = Platform.find_by_slug(platform_slug)
  end
end
