# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe MeSalva::Delivery::TangibleProducts::TangibleProductsShipping do
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

  describe 'for methods calls' do
    context 'for correios lib call' do
      let!(:driver) { MeSalva::Delivery::Drivers::Correios::CorreiosShipping }
      context 'with a tangible product' do
        let!(:tangible_product) { create(:tangible_product, :with_correios_attributes) }
        context 'with a delivery availability object' do
          let!(:delivery_availability) do
            MeSalva::Delivery::Drivers::Correios::CorreiosAvailability.new({ sender_zipcode: 12345678,
                                                                             recipient_zipcode: 98765432 })
          end
          context 'with any uf' do
            let!(:uf) { 'SP' }
            context 'for any service' do
              context 'cheapest_service' do
                it 'calls the drivers method' do
                  instanced_class = double
                  params = { delivery_availability: delivery_availability,
                             tangible_product: tangible_product,
                             uf: uf }
                  expect(driver).to receive(:new).with(params).and_return(instanced_class)
                  expect(instanced_class).to receive(:cheapest_service)
                  described_class.new({ delivery_availability: delivery_availability,
                                        tangible_product: tangible_product,
                                        uf: uf })
                                 .cheapest_service
                end
              end
              context 'service_information' do
                context 'with a service type' do
                  let!(:service_type) { 'SEDEX' }
                  it 'calls the drivers method' do
                    instanced_class = double
                    params = { delivery_availability: delivery_availability,
                               tangible_product: tangible_product,
                               uf: uf }
                    expect(driver).to receive(:new).with(params).and_return(instanced_class)
                    expect(instanced_class).to receive(:service_information).with(service_type)
                    described_class.new({ delivery_availability: delivery_availability,
                                          tangible_product: tangible_product,
                                          uf: uf })
                                   .service_information(service_type)
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
