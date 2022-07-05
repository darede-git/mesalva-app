# frozen_string_literal: true

module ErrorHandler
  def pagarme_validation_handler(e)
    @order.state_machine.transition_to(:invalid)
    error_message = valid_pagarme_error_message(e.message)
    create_checkout_error_event(error_message)
    render_unprocessable_entity(error_message)
  end
end
