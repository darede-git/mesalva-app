# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe MeSalva::Delivery::DeliveryShipping do
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
    context 'with a delivery availability object' do
      let!(:delivery_availability) do
        MeSalva::Delivery::Drivers::Correios::CorreiosAvailability.new({ sender_zipcode: 12345678,
                                                                         recipient_zipcode: 98765432 })
      end
      context 'and a tangible product' do
        let!(:tangible_product) { create(:tangible_product) }
        context 'with a valid uf' do
          let!(:uf) { 'SP' }
          describe 'cheapest_service' do
            let!(:described_class_instance) do
              described_class.new({ delivery_availability: delivery_availability,
                                    tangible_product: tangible_product,
                                    uf: uf })
            end
            context 'for a direct call' do
              it 'raises the not implemented error' do
                expect do
                  described_class_instance.cheapest_service
                end.to raise_error(NotImplementedError, 'Implement this method in a child class')
              end
            end

            describe 'service_information' do
              context 'for a direct call' do
                it 'raises the not implemented error' do
                  expect do
                    described_class_instance.service_information('SEDEX')
                  end.to raise_error(NotImplementedError, 'Implement this method in a child class')
                end
              end
            end

            describe 'generate_posting_code' do
              context 'for a direct call' do
                it 'raises the not implemented error' do
                  expect do
                    described_class_instance.generate_posting_code
                  end.to raise_error(NotImplementedError, 'Implement this method in a child class')
                end
              end
            end
          end
        end
      end
    end
  end
end
