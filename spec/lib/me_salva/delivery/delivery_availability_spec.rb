# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe MeSalva::Delivery::DeliveryAvailability do
  subject { described_class }

  describe 'class attributes' do
    context 'with attributes' do
      it 'has the attributes needed' do
        expect(described_class.instance_methods).to include(:sender_zipcode, :recipient_zipcode)
      end
    end
  end

  describe 'class methods' do
    context 'with methods' do
      it 'has the methods needed' do
        expect(described_class.instance_methods).to include(:service_available?, :services_available)
      end
    end
  end

  describe 'for method calls' do
    let!(:described_class_instance) do
      described_class.new({ sender_zipcode: 12345678, recipient_zipcode: 98765432 })
    end
    describe 'service_available?' do
      context 'for a direct call' do
        it 'raises the not implemented error' do
          expect do
            described_class_instance.service_available?('SEDEX')
          end.to raise_error(NotImplementedError, 'Implement this method in a child class')
        end
      end
    end

    describe 'services_available' do
      context 'for a direct call' do
        it 'raises the not implemented error' do
          expect do
            described_class_instance.services_available
          end.to raise_error(NotImplementedError, 'Implement this method in a child class')
        end
      end
    end
  end
end
