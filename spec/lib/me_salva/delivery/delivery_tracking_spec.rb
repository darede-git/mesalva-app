# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe MeSalva::Delivery::DeliveryTracking do
  include DeliveryTrackingAssertionHelper

  subject { described_class }

  describe 'class attributes' do
    context 'with attributes' do
      it 'has the attributes needed' do
        expect(described_class.instance_methods).to include(:tracking_code, :error, :event_type)
      end
    end
  end

  describe 'class methods' do
    context 'with methods' do
      it 'has the methods needed' do
        expect(described_class.instance_methods).to include(:all_events, :posted?, :out_for_delivery?, :delivered?)
      end
    end
  end

  describe 'for method calls' do
    let!(:described_class_instance) { described_class.new({ tracking_code: 'AB123456789BR' }) }
    describe 'all_events' do
      context 'for a direct call' do
        it 'raises the not implemented error' do
          expect do
            described_class_instance.all_events
          end.to raise_error(NotImplementedError, 'Implement this method in a child class')
        end
      end
    end

    describe 'posted?' do
      context 'for a direct call' do
        it 'raises the not implemented error' do
          expect do
            described_class_instance.posted?
          end.to raise_error(NotImplementedError, 'Implement this method in a child class')
        end
      end
    end

    describe 'out_for_delivery?' do
      context 'for a direct call' do
        it 'raises the not implemented error' do
          expect do
            described_class_instance.out_for_delivery?
          end.to raise_error(NotImplementedError, 'Implement this method in a child class')
        end
      end
    end

    describe 'delivered?' do
      context 'for a direct call' do
        it 'raises the not implemented error' do
          expect do
            described_class_instance.delivered?
          end.to raise_error(NotImplementedError, 'Implement this method in a child class')
        end
      end
    end
  end
end
