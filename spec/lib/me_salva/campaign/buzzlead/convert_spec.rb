# frozen_string_literal: false

require 'rails_helper'

describe MeSalva::Campaign::Buzzlead::Convert do
  let!(:order) { create(:order, :with_utm_buzzlead) }
  let(:error_buzzlead) { MeSalva::Error::BuzzleadApiConnectionError }
  let(:sucess_message) { 'Indicação convertida com sucesso.' }
  let(:error_message) { 'Conversão já gerado para indicação x' }
  let(:sucess_request) do
    double(code: 200,
           parsed_response: { 'success' => true,
                              'message' => sucess_message })
  end
  let(:fail_request) do
    double(code: 500,
           parsed_response: { 'success' => false,
                              'message' => error_message })
  end
  let(:headers) do
    { "x-api-token-buzzlead" => ENV['BUZZLEAD_API_TOKEN'],
      "x-api-key-buzzlead" => ENV['BUZZLEAD_API_KEY'] }
  end

  subject { described_class.new(order) }

  describe '#create' do
    let(:url) do
      "#{ENV['BUZZLEAD_API_URL']}notification/convert"
    end
    let(:body) do
      { codigo: order.utm.utm_content,
        pedido: order.token,
        total: 5.0,
        nome: order.user.name,
        email: order.user.email }
    end
    context 'success request' do
      before do
        allow(HTTParty).to receive(:post)
          .with(url, headers: headers, body: body)
          .and_return(sucess_request)
      end

      it 'returns true' do
        expect(subject.create).to eq(true)
      end
    end

    context 'fail request' do
      before do
        allow(HTTParty).to receive(:post)
          .with(url, headers: headers, body: body)
          .and_return(fail_request)
      end

      it 'raises error' do
        expect { subject.create }.to raise_error(error_buzzlead)
      end
    end
  end

  describe '#confirm' do
    let(:url) do
      ENV['BUZZLEAD_API_URL'] + "bonus/status/#{order.token}/confirmado"
    end

    context 'success request' do
      before do
        allow(HTTParty).to receive(:post)
          .with(url, headers: headers)
          .and_return(sucess_request)
      end

      it 'updates buzzlead processed' do
        expect do
          subject.confirm
        end.to change { order.reload.buzzlead_processed }.from(false).to(true)
      end
    end

    context 'fail request' do
      before do
        allow(HTTParty).to receive(:post)
          .with(url, headers: headers)
          .and_return(fail_request)
      end

      it 'raises error' do
        expect { subject.confirm }.to raise_error(error_buzzlead)
      end
    end
  end
end
