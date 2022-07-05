# frozen_string_literal: true

module SendEmailBankSlipHelper
  def order_paid?(order)
    order.payments.last.state_machine.current_state == 'paid'
  end
end
