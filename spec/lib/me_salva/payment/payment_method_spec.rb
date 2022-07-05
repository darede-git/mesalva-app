# frozen_string_literal: true

require 'me_salva/payment/iugu/payment_method'

describe MeSalva::Payment::Iugu::PaymentMethod do
  subject { described_class.new }

  before do
    stub_const('Iugu::PaymentMethod', double)
  end

  describe '#fetch' do
    it 'returns a payment_method' do
      customer_id = 'A4576A87048C4CD995D04C495FD39C80'
      id = '50C9CBCC680343BE97E522823C94FE41'
      allow(Iugu::PaymentMethod).to receive(:fetch)
        .with(customer_id: customer_id, id: id)
        .and_return(Iugu::PaymentMethod)
      expect(subject.fetch(customer_id, id)).to eq(Iugu::PaymentMethod)
    end
  end

  describe '#create' do
    it 'creates a payment_method' do
      stub_const('Iugu::Customer', double)

      allow(Iugu::Customer)
        .to receive_message_chain(:payment_methods, :create)
        .with(description: 'default',
              token: 'token',
              set_as_default: true)
        .and_return(Iugu::PaymentMethod)

      expect(subject.create(Iugu::Customer, 'token'))
        .to eq(Iugu::PaymentMethod)
    end
  end
end
