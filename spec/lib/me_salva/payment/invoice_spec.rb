# frozen_string_literal: true

require 'me_salva/payment/iugu/invoice'

describe MeSalva::Payment::Iugu::Invoice do
  subject { described_class.new }

  before do
    stub_const('Iugu::Invoice', double)
  end

  describe '#fetch' do
    it 'returns the plan' do
      invoice_id = '53B53D39F7AD44C4B8B873E15F067193'
      allow(Iugu::Invoice).to receive(:fetch)
        .with(invoice_id)
        .and_return(Iugu::Invoice)

      expect(subject.fetch(invoice_id)).to eq(Iugu::Invoice)
    end
  end

  describe '#create' do
    it 'creates an invoice ' do
      allow(Iugu::Invoice).to receive(:create).and_return(Iugu::Invoice)

      customer_id = 'FF3149CE52CB4A789925F154B489BFDD'
      due_date = Time.now
      items = [{ 'description' => 'teste', 'price_cents' => 4000 }]
      discount_cents = 0

      expect(subject.create(customer_id, due_date, items, discount_cents))
        .to eq(Iugu::Invoice)
    end
  end

  describe '#search' do
    it 'returns the customer' do
      allow(Iugu::Invoice).to receive_message_chain(:search, :results)
        .and_return([Iugu::Invoice])
      customer_id = 'FF3149CE52CB4A789925F154B489BFDD'

      expect(subject.search(customer_id)).to eq([Iugu::Invoice])
    end
  end

  describe '#find_invoice_id' do
    it 'returns invoice_id with invoice hash' do
      hash = JSON.parse(File.read('spec/fixtures/charge_response.json'))

      expect(subject.find_invoice_id(hash))
        .to eq('02056E6E7E3347B499B94F5F775A014F')
    end

    it 'returns invoice_id with subscription hash' do
      hash = JSON.parse(File.read('spec/fixtures/subscription_response.json'))

      expect(subject.find_invoice_id(hash))
        .to eq('D9D0A8F68F7F415A87CDC55EC11A7242')
    end
  end

  describe '#refund' do
    it 'return if invoice refunds' do
      invoice_id = '53B53D39F7AD44C4B8B873E15F067193'
      allow(Iugu::Invoice).to receive(:fetch)
        .with(invoice_id)
        .and_return(Iugu::Invoice)

      allow(Iugu::Invoice).to receive(:refund)
        .and_return(Iugu::Invoice)

      expect(subject.refund(invoice_id)).to eq(Iugu::Invoice)
    end
  end
end
