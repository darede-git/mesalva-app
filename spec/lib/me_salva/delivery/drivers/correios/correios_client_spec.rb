# frozen_string_literal: true

require 'spec_helper'

RSpec.describe MeSalva::Delivery::Drivers::Correios::CorreiosClient do
  include MeSalva::Delivery::Drivers::Correios::CorreiosClient

  let!(:correios_client) { MeSalva::Delivery::Drivers::Correios::CorreiosClient }

  describe 'delivery_methods' do
    context 'with the delivery methods available' do
      context 'for the delivery methods mapping' do
        it 'includes methods' do
          expect(correios_client::DELIVERY_METHODS.keys).to include(:PAC, :SEDEX)
        end
        it 'has values for the methods' do
          methods = correios_client::DELIVERY_METHODS
          expect(methods[:PAC]).to eq(3298)
          expect(methods[:SEDEX]).to eq(3220)
        end
      end
    end
  end
  describe 'apis' do
    context 'with the apis available' do
      context 'for the apis mapping' do
        it 'includes apis' do
          expect(correios_client::APIS.keys).to include(:Abrangencia, :ArEletronico, :Calculador)
        end
        it 'has values for the methods' do
          apis = correios_client::APIS
          expect(apis[:Abrangencia]).to eq('https://cws.correios.com.br/cws/abrangenciaService/abrangenciaWS?wsdl')
          expect(apis[:ArEletronico]).to eq('https://apps3.correios.com.br/areletronico/v1/ars/eventos')
          expect(apis[:Calculador]).to eq('http://ws.correios.com.br/calculador/calcprecoprazo.asmx/CalcPrecoPrazo')
        end
      end
    end
  end
  describe 'headers' do
    context 'with the headers available' do
      context 'for the headers mapping' do
        it 'includes headers' do
          expect(correios_client::HEADERS.keys).to include(:json, :xml, :urlencoded)
        end
        it 'has values for the methods' do
          headers = correios_client::HEADERS
          expect(headers[:json]).to eq("Content-Type" => "application/json")
          expect(headers[:xml]).to eq("Content-Type" => "text/xml")
          expect(headers[:urlencoded]).to eq("Content-Type" => "application/x-www-form-urlencoded")
        end
      end
    end
  end
  describe 'method_code' do
    context 'with the delivery methods available' do
      context 'based on delivery methods descriptions' do
        it 'returns the delivery method code' do
          expect(method_code(:PAC)).to eq(3298)
          expect(method_code('PAC')).to eq(3298)
          expect(method_code(:SEDEX)).to eq(3220)
          expect(method_code('SEDEX')).to eq(3220)
        end
      end
    end
  end
  describe 'available_methods' do
    context 'with the delivery methods available' do
      it 'returns all the available delivery methods' do
        expect(available_methods).to eq(%w[PAC SEDEX])
      end
    end
  end
  describe 'client attributes' do
    context 'for a product delivery' do
      let!(:tracking_code) { 'XX123456789BR' }
      it 'has a tracking code attribute defined' do
        expect(correios_client::USERNAME).to eq(ENV['CORREIOS_USERNAME'])
        expect(correios_client::PASSWORD).to eq(ENV['CORREIOS_PASSWORD'])
        expect(correios_client::CONTRACT_CODE).to eq(ENV['CORREIOS_CONTRACT_CODE'])
        expect(correios_client::POST_CODE).to eq(ENV['CORREIOS_POST_CODE'])
      end
    end
  end
  describe 'api_url' do
    context 'with the apis available' do
      context 'based on api description' do
        it 'returns the api url' do
          expect(api_url(:Abrangencia)).to eq('https://cws.correios.com.br/cws/abrangenciaService/abrangenciaWS?wsdl')
          expect(api_url('Abrangencia')).to eq('https://cws.correios.com.br/cws/abrangenciaService/abrangenciaWS?wsdl')
          expect(api_url(:ArEletronico)).to eq('https://apps3.correios.com.br/areletronico/v1/ars/eventos')
          expect(api_url('ArEletronico')).to eq('https://apps3.correios.com.br/areletronico/v1/ars/eventos')
          expect(api_url(:Calculador)).to eq('http://ws.correios.com.br/calculador/calcprecoprazo.asmx/CalcPrecoPrazo')
          expect(api_url('Calculador')).to eq('http://ws.correios.com.br/calculador/calcprecoprazo.asmx/CalcPrecoPrazo')
        end
      end
    end
  end
  describe 'api_header' do
    context 'with the headers available' do
      context 'based on header description' do
        it 'returns the api header' do
          expect(api_header(:json)).to eq("Content-Type" => "application/json")
          expect(api_header('json')).to eq("Content-Type" => "application/json")
          expect(api_header(:xml)).to eq("Content-Type" => "text/xml")
          expect(api_header('xml')).to eq("Content-Type" => "text/xml")
          expect(api_header(:urlencoded)).to(
            eq("Content-Type" => "application/x-www-form-urlencoded")
          )
          expect(api_header('urlencoded')).to(
            eq("Content-Type" => "application/x-www-form-urlencoded")
          )
        end
      end
    end
  end
  describe 'basic_auth' do
    context 'with the basic authentication information' do
      it 'returns the basic authentication object' do
        expect(basic_auth).to eq({ username: ENV['CORREIOS_USERNAME'],
                                   password: ENV['CORREIOS_PASSWORD'] })
      end
    end
  end
end
