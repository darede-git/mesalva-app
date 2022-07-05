# frozen_string_literal: true

require 'me_salva/payment/iugu/invoice'

class RefundsController < ApplicationController
  before_action -> { authenticate(%w[admin]) }
  before_action :set_order

  def update
    return render_not_found unless @order

    if refund
      @order.state_machine.transition_to!(:refunded)
      render_ok(@order)
    else
      render_unprocessable_entity
    end
  end

  private

  def refund
    return iugu_refund if @order.iugu?

    return play_store_refund if @order.play_store?

    pagarme_refund if @order.pagarme?
  end

  def pagarme_refund
    MeSalva::Payment::Pagarme::Refund.new(order: @order).perform
  end

  def iugu_refund
    invoice_client.refund(@order.broker_invoice)
  end

  def play_store_refund
    MeSalva::Payment::PlayStore::Refund.new(@order).perform
  end

  def invoice_client
    @invoice_client ||= MeSalva::Payment::Iugu::Invoice.new
  end

  def set_order
    @order = Order.find_by_token(params[:order_id])
  end
end
