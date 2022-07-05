# frozen_string_literal: true

require 'me_salva/payment/iugu/charge'

describe MeSalva::Payment::Iugu::Charge do
  subject { described_class.new }

  before do
    stub_const('Iugu::Charge', double)
  end

  describe '#bank_slip' do
    it 'creates a bank slip charge' do
      invoice_id = '53B53D39F7AD44C4B8B873E15F067193'
      payer = { name: 'Nome', email: 'email@email.com' }
      allow(Iugu::Charge).to receive(:create)
        .with(method: 'bank_slip', invoice_id: invoice_id, payer: payer)
        .and_return(Iugu::Charge)

      expect(subject.bank_slip(invoice_id, payer)).to eq(Iugu::Charge)
    end
  end

  describe '#credit_card' do
    it 'creates a credit card charge' do
      user_payment_token = '77C2565F6F064A26ABED4255894224F0'
      items = '53B53D39F7AD44C4B8B873E15F067193'
      customer_id = 'FF3149CE52CB4A789925F154B489BFDD'
      installments = 1
      discount_cents = 0

      allow(Iugu::Charge).to receive(:create)
        .with(customer_id: customer_id,
              customer_payment_method_id: user_payment_token,
              items: items,
              months: installments,
              discount_cents: discount_cents)
        .and_return(Iugu::Charge)

      expect(subject.credit_card(items,
                                 user_payment_token,
                                 customer_id,
                                 installments,
                                 discount_cents))
        .to eq(Iugu::Charge)
    end
  end
end
