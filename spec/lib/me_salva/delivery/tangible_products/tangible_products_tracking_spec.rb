# frozen_string_literal: true

require 'spec_helper'
require 'rails_helper'
require 'shoulda/matchers'

RSpec.describe MeSalva::Delivery::TangibleProducts::TangibleProductsTracking do
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
    describe 'all_events' do
      context 'for correios lib call' do
        context 'with valid params' do
          context 'for an available tracking code' do
            let!(:tracking_code) { 'AB123456789BR' }
            it 'returns all events',
               vcr: { cassette_name: 'lib/delivery/correios/tracking/all_events' } do
              result = described_class.new(tracking_code).all_events
              assert_events_tracking_code_found(result)
            end
          end
          context 'for an unavailable tracking code' do
            let!(:tracking_code) { 'AB999999999BR' }
            it 'returns not found',
               vcr: { cassette_name: 'lib/delivery/correios/tracking/events_not_found' } do
              result = described_class.new(tracking_code).all_events
              assert_events_tracking_code_not_found(result)
            end
          end
          context 'with invalid params' do
            context 'for an invalid format tracking code' do
              let!(:tracking_code) { 'AB9999BR' }
              it 'returns the invalid format error',
                 vcr: { cassette_name: 'lib/delivery/correios/tracking/traking_code_invalid_format' } do
                expect do
                  described_class.new(tracking_code).all_events
                end.to raise_error('Código de rastreamento inválido')
              end
            end
          end
        end
      end
    end

    describe 'posted?' do
      context 'for correios lib call' do
        context 'with valid params' do
          context 'for an available tracking code' do
            context 'when the object has already been posted' do
              let!(:tracking_code) { 'AB123456789BR' }
              it 'returns true',
                 vcr: { cassette_name: 'lib/delivery/correios/tracking/posted_true' } do
                result = described_class.new(tracking_code).posted?
                assert_posted(result)
              end
            end
            context 'when the object has not yet been posted' do
              let!(:tracking_code) { 'AB123456789BR' }
              it 'returns true',
                 vcr: { cassette_name: 'lib/delivery/correios/tracking/posted_false' } do
                result = described_class.new(tracking_code).posted?
                assert_not_posted(result)
              end
            end
          end
          context 'for an unavailable tracking code' do
            let!(:tracking_code) { 'AB999999999BR' }
            it 'returns not found',
               vcr: { cassette_name: 'lib/delivery/correios/tracking/events_not_found' } do
              result = described_class.new(tracking_code).posted?
              assert_events_tracking_code_not_found(result)
            end
          end
          context 'with invalid params' do
            context 'for an invalid format tracking code' do
              let!(:tracking_code) { 'AB9999BR' }
              it 'returns the invalid format error',
                 vcr: { cassette_name: 'lib/delivery/correios/tracking/traking_code_invalid_format' } do
                expect do
                  described_class.new(tracking_code).posted?
                end.to raise_error('Código de rastreamento inválido')
              end
            end
          end
        end
      end
    end

    describe 'out_for_delivery?' do
      context 'for correios lib call' do
        context 'with valid params' do
          context 'for an available tracking code' do
            context 'when the object is already out for delivery' do
              let!(:tracking_code) { 'AB123456789BR' }
              it 'returns true',
                 vcr: { cassette_name: 'lib/delivery/correios/tracking/out_for_delivery_true' } do
                result = described_class.new(tracking_code).out_for_delivery?
                assert_out_for_delivery(result)
              end
            end
            context 'when the object is not yet out for delivery' do
              let!(:tracking_code) { 'AB123456789BR' }
              it 'returns true',
                 vcr: { cassette_name: 'lib/delivery/correios/tracking/out_for_delivery_false' } do
                result = described_class.new(tracking_code).out_for_delivery?
                assert_not_out_for_delivery(result)
              end
            end
          end
          context 'for an unavailable tracking code' do
            let!(:tracking_code) { 'AB999999999BR' }
            it 'returns not found',
               vcr: { cassette_name: 'lib/delivery/correios/tracking/events_not_found' } do
              result = described_class.new(tracking_code).out_for_delivery?
              assert_events_tracking_code_not_found(result)
            end
          end
          context 'with invalid params' do
            context 'for an invalid format tracking code' do
              let!(:tracking_code) { 'AB9999BR' }
              it 'returns the invalid format error',
                 vcr: { cassette_name: 'lib/delivery/correios/tracking/traking_code_invalid_format' } do
                expect do
                  described_class.new(tracking_code).out_for_delivery?
                end.to raise_error('Código de rastreamento inválido')
              end
            end
          end
        end
      end
    end

    describe 'delivered?' do
      context 'for correios lib call' do
        context 'with valid params' do
          context 'for an available tracking code' do
            context 'when the object is already been delivered' do
              let!(:tracking_code) { 'AB123456789BR' }
              it 'returns true',
                 vcr: { cassette_name: 'lib/delivery/correios/tracking/delivered_true' } do
                result = described_class.new(tracking_code).delivered?
                assert_delivered(result)
              end
            end
            context 'when the object is not yet been delivered' do
              let!(:tracking_code) { 'AB123456789BR' }
              it 'returns true',
                 vcr: { cassette_name: 'lib/delivery/correios/tracking/delivered_false' } do
                result = described_class.new(tracking_code).delivered?
                assert_not_delivered(result)
              end
            end
          end
          context 'for an unavailable tracking code' do
            let!(:tracking_code) { 'AB999999999BR' }
            it 'returns not found',
               vcr: { cassette_name: 'lib/delivery/correios/tracking/events_not_found' } do
              result = described_class.new(tracking_code).delivered?
              assert_events_tracking_code_not_found(result)
            end
          end
          context 'with invalid params' do
            context 'for an invalid format tracking code' do
              let!(:tracking_code) { 'AB9999BR' }
              it 'returns the invalid format error',
                 vcr: { cassette_name: 'lib/delivery/correios/tracking/traking_code_invalid_format' } do
                expect do
                  described_class.new(tracking_code).delivered?
                end.to raise_error('Código de rastreamento inválido')
              end
            end
          end
        end
      end
    end
  end
end
