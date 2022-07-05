# frozen_string_literal: true

require 'me_salva/payment/iugu/client'

describe MeSalva::Payment::Iugu::Client do
  describe '#set_api_key' do
    let(:test_instance) { TestClass.new }
    ENV['IUGU_API_KEY'] = '400a36086a51f7454d34a863521fa46a'

    context 'if Iugu api key is not set' do
      it 'sets the api-key' do
        ::Iugu.api_key = nil

        expect(test_instance.set_api_key).to eq nil
        expect(::Iugu.api_key).to eq '400a36086a51f7454d34a863521fa46a'
      end
    end

    context 'if Iugu api key is already set' do
      it 'does not change the api-key' do
        ::Iugu.api_key = '1'

        expect(test_instance.set_api_key).to eq nil
        expect(::Iugu.api_key).to eq '1'
      end
    end
  end
end

class TestClass; include MeSalva::Payment::Iugu::Client; end
