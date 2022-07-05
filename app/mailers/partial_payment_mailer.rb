# frozen_string_literal: true

class PartialPaymentMailer < ApplicationMailer
  default from: "Me Salva! <#{ENV['MAIL_SENDER']}>"

  def authorized_access(order)
    attachments['info.csv'] = order.report_csv
    mail(to: ["financeiro@mesalva.com", "relacionamento@mesalva.com"], \
         subject: "Acesso liberado para pagamento parcial")
  end

  def non_authorized(order)
    attachments['info.csv'] = order.report_csv
    mail(to: ["financeiro@mesalva.com", "relacionamento@mesalva.com"], \
         subject: "Alerta! Pagamento parcial com valor fora da regra")
  end
end
