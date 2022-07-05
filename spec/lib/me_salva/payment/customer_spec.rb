# frozen_string_literal: true

require 'me_salva/payment/iugu/customer'

describe MeSalva::Payment::Iugu::Customer do
  subject { described_class.new }

  before do
    stub_const('Iugu::Customer', double)
  end

  describe '#create' do
    it 'creates a customer' do
      allow(Iugu::Customer).to receive(:create) { Iugu::Customer }
      params = { email: 'darth@vader.com', name: 'Vader',
                 cpf_cnpj: '11111111111', zip_code: '12345-678',
                 street: 'Estrela da Morte', number: 2 }

      expect(subject.create(params)).to eq Iugu::Customer
    end
  end

  describe '#search' do
    it 'returns the customer' do
      allow(Iugu::Customer).to receive_message_chain(:search, :results)
        .and_return([Iugu::Customer])
      email = 'teste@teste.com'

      expect(subject.search(email)).to eq(Iugu::Customer)
    end
  end
end
