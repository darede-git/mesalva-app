# frozen_string_literal: true

require 'rails_helper'

describe MeSalva::Payment::Iugu::Order do
  let(:orders) do
    %i[paid_order pending_order canceled_order
       expired_status_order invalid_order]
      .map { |order| create(order) }
  end

  let!(:order_not_found) do
    create(:order_not_found, broker: 'iugu')
  end

  let!(:valid_invoice_response) do
    Iugu::Invoice.new(status: 'paid')
  end

  let!(:canceled_invoice_response) do
    Iugu::Invoice.new(status: 'canceled')
  end

  context 'Some orders have status paid at Iugu and not found at Me Salva!' do
    it 'corrects orders with wrong status and does not update the others' do
      allow(Iugu::Invoice).to receive(:fetch)
        .and_return(valid_invoice_response)

      MeSalva::Payment::Iugu::Order.reprocess

      expect(order_not_found.reload.status).to eq(2)
      orders.each do |order|
        expect(order.status).to eq(order.reload.status)
      end
    end

    it 'does not change any order when it is not paid at Iugu' do
      allow(Iugu::Invoice).to receive(:fetch)
        .and_return(canceled_invoice_response)

      MeSalva::Payment::Iugu::Order.reprocess

      orders << order_not_found
      orders.each do |order|
        expect(order.status).to eq(order.reload.status)
      end
    end
  end
end
