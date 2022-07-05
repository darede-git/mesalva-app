# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe MeSalva::Delivery::Drivers::Correios::CorreiosAvailability do
  subject { described_class }

  describe 'class attributes' do
    context 'with attributes' do
      it 'has the attributes needed' do
        expect(described_class.instance_methods).to include(:sender_zipcode,
                                                            :recipient_zipcode)
      end
    end
  end

  describe 'class methods' do
    context 'with methods' do
      it 'has the methods needed' do
        expect(described_class.instance_methods).to include(:service_available?,
                                                            :services_available)
      end
    end
  end

  describe 'for method calls' do
    describe 'service_available?' do
      context 'for correios lib call' do
        context 'with valid params' do
          context 'for a available service' do
            let!(:service_type) { 'SEDEX' }
            let!(:sender_zipcode) { 90450020 }
            let!(:recipient_zipcode) { 90450020 }
            it 'returns true for the service availability',
               vcr: { cassette_name: 'lib/delivery/correios/availability/service_available' } do
              availability = described_class.new({ sender_zipcode: sender_zipcode,
                                                   recipient_zipcode: recipient_zipcode })
                                            .service_available?(service_type)
              expect(availability).to eq(true)
            end
          end
          context 'for an unavailable service' do
            let!(:service_type) { 'SEDEX' }
            let!(:sender_zipcode) { 90450020 }
            let!(:recipient_zipcode) { 12345678 }
            it 'returns true for the service availability',
               vcr: { cassette_name: 'lib/delivery/correios/availability/service_unavailable' } do
              availability = described_class.new({ sender_zipcode: sender_zipcode,
                                                   recipient_zipcode: recipient_zipcode })
                                            .service_available?(service_type)
              expect(availability).to eq(false)
            end
          end
        end
        context 'with invalid params' do
          context 'for a invalid service type' do
            let!(:service_type) { 'SEDEX10' }
            let!(:sender_zipcode) { 90450020 }
            let!(:recipient_zipcode) { 90450020 }
            it 'raises the invalid_service error',
               vcr: { cassette_name: 'lib/delivery/correios/availability/invalid_service_type' } do
              expect do
                described_class.new({ sender_zipcode: sender_zipcode,
                                      recipient_zipcode: recipient_zipcode })
                               .service_available?(service_type)
              end.to raise_error('Tipo de serviço inválido')
            end
          end
          context 'for a invalid zip code' do
            context 'when the sender zip code is the invalid one' do
              let!(:service_type) { 'SEDEX' }
              let!(:sender_zipcode) { 123456789 }
              let!(:recipient_zipcode) { 90450020 }
              it 'raises the invalid_zipcode error',
                 vcr: { cassette_name: 'lib/delivery/correios/availability/invalid_zipcode' } do
                expect do
                  described_class.new({ sender_zipcode: sender_zipcode,
                                        recipient_zipcode: recipient_zipcode })
                                 .service_available?(service_type)
                end.to raise_error('CEP inválido')
              end
            end
            context 'when the recipient zip code is the invalid one' do
              let!(:service_type) { 'SEDEX' }
              let!(:sender_zipcode) { 90450020 }
              let!(:recipient_zipcode) { 123456789 }
              it 'raises the invalid_zipcode error',
                 vcr: { cassette_name: 'lib/delivery/correios/availability/invalid_zipcode' } do
                expect do
                  described_class.new({ sender_zipcode: sender_zipcode,
                                        recipient_zipcode: recipient_zipcode })
                                 .service_available?(service_type)
                end.to raise_error('CEP inválido')
              end
            end
          end
        end
      end
    end

    describe 'services_available' do
      context 'for the configured driver lib call' do
        context 'with valid params' do
          let!(:sender_zipcode) { 90450020 }
          let!(:recipient_zipcode) { 90450020 }
          let!(:described_class_instance) do
            described_class.new({ sender_zipcode: sender_zipcode,
                                  recipient_zipcode: recipient_zipcode })
          end
          context 'for no available services' do
            it 'returns an empty array',
               vcr: { cassette_name: 'lib/delivery/correios/availability/services_available_empty' } do
              services_available = described_class_instance.services_available
              expect(services_available[:services_available]).to eq([])
            end
          end
          context 'for just one available service' do
            it 'returns the only one service available',
               vcr: { cassette_name: 'lib/delivery/correios/availability/services_available_one' } do
              services_available = described_class_instance.services_available
              expect(services_available[:services_available]).to include('PAC')
            end
          end
          context 'for multiple available services' do
            it 'returns true for the service availability',
               vcr: { cassette_name: 'lib/delivery/correios/availability/services_available_multiple' } do
              services_available = described_class_instance.services_available
              expect(services_available[:services_available]).to include('SEDEX', 'PAC')
            end
          end
        end
        context 'with invalid params' do
          context 'for a invalid zip code' do
            context 'when the sender zip code is the invalid one' do
              let!(:sender_zipcode) { 123456789 }
              let!(:recipient_zipcode) { 90450020 }
              it 'raises the invalid_zipcode error',
                 vcr: { cassette_name: 'lib/delivery/correios/availability/invalid_zipcode' } do
                expect do
                  described_class.new({ sender_zipcode: sender_zipcode,
                                        recipient_zipcode: recipient_zipcode })
                                 .services_available
                end.to raise_error('CEP inválido')
              end
            end
            context 'when the recipient zip code is the invalid one' do
              let!(:sender_zipcode) { 90450020 }
              let!(:recipient_zipcode) { 123456789 }
              it 'raises the invalid_zipcode error',
                 vcr: { cassette_name: 'lib/delivery/correios/availability/invalid_zipcode' } do
                expect do
                  described_class.new({ sender_zipcode: sender_zipcode,
                                        recipient_zipcode: recipient_zipcode })
                                 .services_available
                end.to raise_error('CEP inválido')
              end
            end
          end
        end
      end
    end
  end
end
