# frozen_string_literal: true

class CheckoutMailer < ApplicationMailer
  include ActionView::Helpers::NumberHelper

  before_action :set_order,
                :set_first_name,
                :set_email,
                :set_subject,
                :set_preheader,
                :set_messages

  before_action :set_bank_slip,
                :set_barcode,
                :set_price,
                :set_due_date, only: :bank_slip_email

  default from: 'Me Salva! <pagamentos@mesalva.com>'

  attr_reader :order,
              :first_name,
              :email,
              :bank_slip,
              :subject,
              :price,
              :due_date,
              :barcode,
              :initial_message_html,
              :initial_message_text,
              :final_message_html,
              :final_message_text

  DEFAULT_DAYS_INTERVAL_TO_BANK_SLIP_DUE_DATE = 1

  def bank_slip_email
    send_email if bank_slip_email_information_ok?
  end

  def bank_slip_overdued_email
    send_email if overdued_email_information_ok?
  end

  private

  def set_order
    @order = params[:order]
  end

  def set_first_name
    @first_name = @order.user.name.partition(" ").first.capitalize
  end

  def set_email
    @email = @order.email
  end

  def set_bank_slip
    @bank_slip = @order.payments.last[:pdf]
  end

  def set_price
    @price = number_to_currency(@order[:price_paid].to_f,
                                { unit: t('number.currency.format.unit'),
                                  separator: t('number.currency.format.separator'),
                                  precision: t('number.currency.format.precision') })
  end

  def set_due_date
    @due_date = I18n.l((Date.today + DEFAULT_DAYS_INTERVAL_TO_BANK_SLIP_DUE_DATE), format: :long)
  end

  def set_barcode
    @barcode = @order.payments.last[:barcode]
  end

  def set_subject
    @subject = t("mailer.checkout.#{params[:email_type]}.subject")
  end

  def set_preheader
    @preheader = t("mailer.checkout.#{params[:email_type]}.preheader_base", due_date: @due_date)
  end

  def set_initial_message_html
    @initial_message_html = t("mailer.checkout.#{params[:email_type]}.initial_message",
                              plans: "<a href=#{ENV['MESALVA_PLANS_URL']}>entrar no site</a>")
  end

  def set_initial_message_text
    @initial_message_text = t("mailer.checkout.#{params[:email_type]}.initial_message",
                              plans: "entrar no site em #{ENV['MESALVA_PLANS_URL']}")
  end

  def set_final_message_html
    @final_message_html = t("mailer.checkout.#{params[:email_type]}.final_message",
                            help_center: "<a href=#{ENV['HELP_CENTER_URL']}>Central de Ajuda</a>",
                            whatsapp: "<a href=#{ENV['WHATSAPP_URL']}>WhatsApp</a>")
  end

  def set_final_message_text
    @final_message_text = t("mailer.checkout.#{params[:email_type]}.final_message",
                            help_center: "Central de Ajuda em #{ENV['HELP_CENTER_URL']}",
                            whatsapp: "WhatsApp em #{ENV['WHATSAPP_URL']}")
  end

  def set_messages
    set_initial_message_html
    set_initial_message_text
    set_final_message_html
    set_final_message_text
  end

  def send_email
    mail to: @email, subject: @subject
  end

  def bank_slip_email_information_ok?
    order_information_ok? &&
      email_information_ok? &&
      email_body_information_ok? &&
      payment_information_ok?
  end

  def overdued_email_information_ok?
    order_information_ok? && email_information_ok?
  end

  def order_information_ok?
    @order.present?
  end

  def email_information_ok?
    @first_name.present? &&
      @email.present? &&
      @subject.present? &&
      @preheader.present?
  end

  def email_body_information_ok?
    @initial_message_html.present? &&
      @initial_message_text.present? &&
      @final_message_html.present? &&
      @final_message_text.present?
  end

  def payment_information_ok?
    @bank_slip.present? &&
      @price.present? &&
      @due_date.present? &&
      @barcode.present?
  end
end
