# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe MeSalva::Delivery::Drivers::Correios::CorreiosShipping do
  include DeliveryShippingAssertionHelper

  subject { described_class }

  describe 'class attributes' do
    context 'with attributes' do
      it 'has the attributes needed' do
        expect(described_class.instance_methods).to include(:delivery_availability, :tangible_product, :uf)
      end
    end
  end

  describe 'class methods' do
    context 'with methods' do
      it 'has the methods needed' do
        expect(described_class.instance_methods).to include(:cheapest_service,
                                                            :service_information,
                                                            :generate_posting_code)
      end
    end
  end

  describe 'for method calls' do
    describe 'for class instance' do
      context 'with invalid params' do
        context 'with a valid tangible product' do
          let!(:tangible_product) { create(:tangible_product, :with_correios_attributes) }
          context 'with an invalid uf' do
            let!(:uf) { 'AB' }
            context 'with a delivery availability object' do
              let!(:delivery_availability) do
                MeSalva::Delivery::Drivers::Correios::CorreiosAvailability.new({ sender_zipcode: 12345678,
                                                                                 recipient_zipcode: 98765432 })
              end
              it 'raises the uf error' do
                expect do
                  described_class.new({ delivery_availability: delivery_availability,
                                        tangible_product: tangible_product,
                                        uf: uf })
                end.to raise_error('UF inválido')
              end
            end
          end
        end
        context 'for an invalid tangible product' do
          context 'with a valid uf' do
            let!(:uf) { 'SP' }
            context 'with a delivery availability object' do
              let!(:delivery_availability) do
                MeSalva::Delivery::Drivers::Correios::CorreiosAvailability.new({ sender_zipcode: 12345678,
                                                                                 recipient_zipcode: 98765432 })
              end
              context 'when the tangible product does not exist' do
                let!(:tangible_product) { nil }
                it 'raises the tangible_product error' do
                  expect do
                    described_class.new({ delivery_availability: delivery_availability,
                                          tangible_product: tangible_product,
                                          uf: uf })
                  end.to raise_error('Produto inválido')
                end
              end
              context 'when weight field is invalid' do
                let!(:tangible_product) { create(:tangible_product, :with_correios_attributes, weight: nil) }
                it 'raises the invalid_weight error' do
                  expect do
                    described_class.new({ delivery_availability: delivery_availability,
                                          tangible_product: tangible_product,
                                          uf: uf })
                  end.to raise_error('Peso do produto inválido')
                end
              end
              context 'when height field is invalid' do
                let!(:tangible_product) { create(:tangible_product, :with_correios_attributes, height: nil) }
                it 'raises the invalid_height error' do
                  expect do
                    described_class.new({ delivery_availability: delivery_availability,
                                          tangible_product: tangible_product,
                                          uf: uf })
                  end.to raise_error('Altura do produto inválida')
                end
              end
              context 'when width field is invalid' do
                let!(:tangible_product) { create(:tangible_product, :with_correios_attributes, width: nil) }
                it 'raises the invalid_width error' do
                  expect do
                    described_class.new({ delivery_availability: delivery_availability,
                                          tangible_product: tangible_product,
                                          uf: uf })
                  end.to raise_error('Largura do produto inválida')
                end
              end
              context 'when length field is invalid' do
                let!(:tangible_product) { create(:tangible_product, :with_correios_attributes, length: nil) }
                it 'raises the invalid_length error' do
                  expect do
                    described_class.new({ delivery_availability: delivery_availability,
                                          tangible_product: tangible_product,
                                          uf: uf })
                  end.to raise_error('Comprimento do produto inválido')
                end
              end
            end
          end
        end
        context 'for an invalid zipcode' do
          context 'with a tangible product' do
            let!(:tangible_product) { create(:tangible_product, :with_correios_attributes) }
            context 'with a valid uf' do
              let!(:uf) { 'SP' }
              context 'with an invalid zip code' do
                context 'when the sender zip code is the invalid one' do
                  let!(:delivery_availability) do
                    MeSalva::Delivery::Drivers::Correios::CorreiosAvailability.new({ sender_zipcode: 123456789,
                                                                                     recipient_zipcode: 98765432 })
                  end
                  it 'raises the invalid_zipcode error',
                     vcr: { cassette_name: 'lib/delivery/correios/availability/invalid_zipcode' } do
                    expect do
                      described_class.new({ delivery_availability: delivery_availability,
                                            tangible_product: tangible_product,
                                            uf: uf })
                                     .cheapest_service
                    end.to raise_error('CEP inválido')
                  end
                end
                context 'when the recipient zip code is the invalid one' do
                  let!(:delivery_availability) do
                    MeSalva::Delivery::Drivers::Correios::CorreiosAvailability.new({ sender_zipcode: 12345678,
                                                                                     recipient_zipcode: 987654321 })
                  end
                  it 'raises the invalid_zipcode error',
                     vcr: { cassette_name: 'lib/delivery/correios/availability/invalid_zipcode' } do
                    expect do
                      described_class.new({ delivery_availability: delivery_availability,
                                            tangible_product: tangible_product,
                                            uf: uf })
                                     .cheapest_service
                    end.to raise_error('CEP inválido')
                  end
                end
              end
            end
          end
        end
      end
    end

    describe 'for methods calls' do
      describe 'cheapest_service' do
        context 'for correios lib call' do
          context 'with valid params' do
            context 'with a tangible product' do
              let!(:tangible_product) { create(:tangible_product, :with_correios_attributes) }
              context 'with a delivery availability object' do
                let!(:delivery_availability) do
                  MeSalva::Delivery::Drivers::Correios::CorreiosAvailability.new({ sender_zipcode: 12345678,
                                                                                   recipient_zipcode: 98765432 })
                end
                context 'when there is an available service' do
                  context 'when the uf is different than rs' do
                    let!(:uf) { 'SP' }
                    context 'for the sedex service' do
                      it 'returns sedex as the cheapest service',
                         vcr: { cassette_name: 'lib/delivery/correios/shipping/cheapest_service_sedex' } do
                        cheapest_service = described_class.new({ delivery_availability: delivery_availability,
                                                                 tangible_product: tangible_product,
                                                                 uf: uf })
                                                          .cheapest_service
                        assert_cheapest_service_sedex(cheapest_service)
                      end
                    end
                    context 'for the pac service' do
                      it 'returns pac as the cheapest service',
                         vcr: { cassette_name: 'lib/delivery/correios/shipping/cheapest_service_pac' } do
                        cheapest_service = described_class.new({ delivery_availability: delivery_availability,
                                                                 tangible_product: tangible_product,
                                                                 uf: uf })
                                                          .cheapest_service
                        assert_cheapest_service_pac(cheapest_service)
                      end
                    end
                  end
                  context 'when the uf is rs' do
                    let!(:uf) { 'RS' }
                    it 'returns sedex as the cheapest service',
                       vcr: { cassette_name: 'lib/delivery/correios/shipping/specific_rules' } do
                      cheapest_service = described_class.new({ delivery_availability: delivery_availability,
                                                               tangible_product: tangible_product,
                                                               uf: uf })
                                                        .cheapest_service
                      assert_cheapest_service_uf_rs(cheapest_service)
                    end
                  end
                end
                context 'when there is no service available' do
                  context 'with any uf' do
                    let!(:uf) { 'SP' }
                    it 'returns none',
                       vcr: { cassette_name: 'lib/delivery/correios/shipping/no_service_available' } do
                      cheapest_service = described_class.new({ delivery_availability: delivery_availability,
                                                               tangible_product: tangible_product,
                                                               uf: uf })
                                                        .cheapest_service
                      assert_cheapest_service_none(cheapest_service)
                    end
                  end
                end
              end
            end
          end
        end
      end

      describe 'service_information' do
        context 'for correios lib call' do
          context 'with a tangible product' do
            let!(:tangible_product) { create(:tangible_product, :with_correios_attributes) }
            context 'with a delivery availability object' do
              let!(:delivery_availability) do
                MeSalva::Delivery::Drivers::Correios::CorreiosAvailability.new({ sender_zipcode: 12345678,
                                                                                 recipient_zipcode: 98765432 })
              end
              context 'with an uf' do
                let!(:uf) { 'SP' }
                context 'with valid params' do
                  context 'when there is an available service' do
                    context 'for the sedex service' do
                      it 'returns the price',
                         vcr: { cassette_name: 'lib/delivery/correios/shipping/service_sedex' } do
                        service_information = described_class.new({ delivery_availability: delivery_availability,
                                                                    tangible_product: tangible_product,
                                                                    uf: uf })
                                                             .service_information('SEDEX')
                        assert_service_sedex(service_information)
                      end
                    end
                    context 'for the pac service' do
                      it 'returns the price',
                         vcr: { cassette_name: 'lib/delivery/correios/shipping/service_pac' } do
                        service_information = described_class.new({ delivery_availability: delivery_availability,
                                                                    tangible_product: tangible_product,
                                                                    uf: uf })
                                                             .service_information('PAC')
                        assert_service_pac(service_information)
                      end
                    end
                  end
                  context 'when there is no service available' do
                    context 'for the sedex service' do
                      it 'returns none',
                         vcr: { cassette_name: 'lib/delivery/correios/shipping/no_service_available' } do
                        service_information = described_class.new({ delivery_availability: delivery_availability,
                                                                    tangible_product: tangible_product,
                                                                    uf: uf })
                                                             .service_information('SEDEX')
                        assert_service_none(service_information)
                      end
                    end
                    context 'for the pac service' do
                      it 'returns none',
                         vcr: { cassette_name: 'lib/delivery/correios/shipping/no_service_available' } do
                        service_information = described_class.new({ delivery_availability: delivery_availability,
                                                                    tangible_product: tangible_product,
                                                                    uf: uf })
                                                             .service_information('PAC')
                        assert_service_none(service_information)
                      end
                    end
                  end
                end
                context 'with invalid params' do
                  context 'for an invalid service name' do
                    it 'raises the service error' do
                      expect do
                        described_class.new({ delivery_availability: delivery_availability,
                                              tangible_product: tangible_product,
                                              uf: uf })
                                       .service_information('ANOTHER_SERVICE')
                      end.to raise_error('Tipo de serviço inválido')
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
