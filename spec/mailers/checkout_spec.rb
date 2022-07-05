# frozen_string_literal: true

require 'spec_helper'

describe CheckoutMailer do
  describe 'bank slip email sender' do
    let(:order) { create(:order) }
    let(:mail) do
      CheckoutMailer.with(order: order,
                          email_type: 'bank_slip_after_checkout')
                    .bank_slip_email
    end
    it 'renders the email header' do
      order.payments = [create(:payment, :bank_slip)]
      expect(mail.subject).to eql(t('mailer.checkout.bank_slip_after_checkout.subject'))
      expect(mail.to).to eql([order.email])
      expect(mail.from).to eql(['pagamentos@mesalva.com'])
    end
  end
  describe 'bank slip on last day to be overdued email sender' do
    let(:order) { create(:order) }
    let(:mail) do
      CheckoutMailer.with(order: order,
                          email_type: 'bank_slip_last_day')
                    .bank_slip_email
    end
    it 'renders the email header' do
      order.payments = [create(:payment, :bank_slip)]
      expect(mail.subject).to eql(t('mailer.checkout.bank_slip_last_day.subject'))
      expect(mail.to).to eql([order.email])
      expect(mail.from).to eql(['pagamentos@mesalva.com'])
    end
  end
  describe 'bank slip overdued email sender' do
    let(:order) { create(:order) }
    let(:mail) do
      CheckoutMailer.with(order: order,
                          email_type: 'bank_slip_overdue')
                    .bank_slip_overdued_email
    end
    it 'renders the email header' do
      order.payments = [create(:payment, :bank_slip)]
      expect(mail.subject).to eql(t('mailer.checkout.bank_slip_overdue.subject'))
      expect(mail.to).to eql([order.email])
      expect(mail.from).to eql(['pagamentos@mesalva.com'])
    end
  end
end
