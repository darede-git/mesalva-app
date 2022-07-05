# frozen_string_literal: true

require 'me_salva/payment/pagarme/client'

describe MeSalva::Payment::Pagarme::Client do
  describe '#set_api_key' do
    let(:test_instance) { ClassTest.new }
    it 'sets pagar me api-key' do
      expect(test_instance.set_api_key).to eq(ENV['PAGARME_API_KEY'])
    end
  end
end

class ClassTest; include MeSalva::Payment::Pagarme::Client; end
