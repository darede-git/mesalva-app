# frozen_string_literal: true

class PlatformMailer < ApplicationMailer
  def platform_account_created(**params)
    @email = params[:email]
    @password = params[:password]
    @user = params[:user]
    set_platform(params[:platform_slug])
    platform_mail_content(@platform.mail_invite)
    mail to: @email, subject: "Bem-vindo(a) à Plataforma MS!#{platform_sufix}", from: sender
  end

  def platform_voucher_alert(email, platform_slug, voucher)
    @email = email
    @token = voucher.token
    @first_name = voucher.first_name
    set_platform(platform_slug)
    prefix = @first_name ? "#{@first_name} - " : ""
    mail to: @email, subject: "#{prefix}Acesso liberado ao Me Salva! para o ENEM", from: sender
  end

  def platform_access_granted(**params)
    @email = params[:email]
    @user = params[:user]
    set_platform(params[:platform_slug])
    platform_mail_content(@platform.mail_grant_access)
    mail to: @email, subject: "Bem-vindo(a) à Plataforma MS!#{platform_sufix}", from: sender
  end

  def platform_mail_content(content_base)
    @content = MeSalva::HtmlTemplateConverter.new(content_base).convert(
      user_name: @user.name,
      user_email: @user.email,
      user_password: @password,
      platform_name: @platform.name,
      platform_domain: @platform.domain,
      platform_slug: @platform.slug
    ).html_safe
  end

  private

  def platform_sufix
    return '' if @platform.nil? || @platform.name.nil?

    " - #{@platform.name}"
  end
end
