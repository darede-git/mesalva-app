# frozen_string_literal: true

require 'me_salva/payment/play_store/invoice'
require 'me_salva/error/google_api_connection_error'
require 'spec_helper'

describe MeSalva::Payment::PlayStore::Client do
  subject { described_class }
  let(:access_code_response) do
    JSON.parse(File.read('spec/fixtures/google/access_token.json'))
  end
  let(:order_info_response) do
    JSON.parse(File.read('spec/fixtures/google/order_data.json'))
  end
  let(:access_token_sucess_response) do
    double(code: 200, parsed_response: access_code_response)
  end
  let(:failure_response) do
    double(code: 401, parsed_response: 'invalid permission')
  end
  let(:sucess_order_info_response) do
    double(code: 200, parsed_response: order_info_response)
  end
  let(:connection_error) do
    MeSalva::Error::GoogleApiConnectionError
  end
  let(:succesful_refund) do
    double(code: 204)
  end
  let(:order) do
    create(:in_app_order)
  end

  before do
    allow(HTTParty).to receive(:post).and_return(access_token_sucess_response)
  end

  describe '#new' do
    context 'GOOGLE_API_REFRESH_TOKEN is invalid' do
      before do
        allow(HTTParty).to receive(:post)
          .and_return(failure_response)
      end
      it 'should raise error' do
        expect { described_class.new }.to raise_error(connection_error)
      end
    end
  end

  describe '#subscription_last_invoice_from' do
    context 'GOOGLE_API_REFRESH_TOKEN is valid' do
      context 'access_token is valid' do
        before do
          allow(HTTParty).to receive(:get)
            .and_return(sucess_order_info_response)
        end
        it 'returns data about an order' do
          expect(subject.new.subscription_last_invoice_from(order))
            .to be_a(MeSalva::Payment::PlayStore::Invoice)
        end
      end

      context 'access_token is invalid' do
        before do
          allow(HTTParty).to receive(:get).and_return(failure_response)
        end
        it 'raises error' do
          expect { subject.new.subscription_last_invoice_from(order) }
            .to raise_error(connection_error)
        end
      end
    end

    context 'GOOGLE_API_REFRESH_TOKEN is invalid' do
      context 'access_token is invalid' do
        before do
          allow(HTTParty).to receive(:post)
            .and_return(access_token_sucess_response, failure_response)
          allow(HTTParty).to receive(:get).and_return(failure_response)
        end
        it 'raises an error' do
          expect { subject.new.subscription_last_invoice_from(order) }
            .to raise_error(connection_error)
        end
      end
    end
  end

  describe '#refund' do
    context 'refund request returns no content status' do
      before do
        allow(HTTParty).to receive(:post)
          .and_return(access_token_sucess_response, succesful_refund)
      end
      it 'should be true' do
        expect(described_class.new.refund(order)).to be_truthy
        expect(HTTParty).to have_received(:post).twice
      end
    end

    context 'refund request returns a diffent status' do
      before do
        allow(HTTParty).to receive(:post)
          .and_return(access_token_sucess_response, failure_response)
      end
      it 'should return false' do
        expect(described_class.new.refund(order)).to be_falsey
      end
    end
  end
end
