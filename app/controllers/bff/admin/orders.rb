# frozen_string_literal: true

class Bff::Admin::Orders < Bff::Admin::BffAdminBaseController

  def update_price_paid
    order = Order.by_asaas.by_token(params['token'])
    return render_not_found unless order.present?

    order.price_paid = params['new_price_paid'].to_f
    render_ok(order) if order.save
  end
end
