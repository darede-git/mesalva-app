# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Price, type: :model do
  context 'validations' do
    it do
      should validate_inclusion_of(:price_type).in_array(
        %w[credit_card bank_slip app_store play_store]
      )
    end
    should_be_present(:value)
  end

  let!(:price_one) { create(:price) }
  let!(:price_two) { create(:price, price_type: 'bank_slip') }
  let!(:price_three) { create(:price) }

  let!(:package_one) do
    create(:package, prices: [price_one, price_two])
  end
  let!(:package_two) { create(:package, prices: [price_three]) }

  context 'price with usd currency' do
    it 'should be valid' do
      price = create(:price,
                     price_type: 'app_store', currency: 'USD')
      expect(price).to be_valid
    end
  end

  context 'scopes' do
    context '.by_package_and_price_type' do
      context 'with a filter that match' do
        it 'get price with package id and price type arguments' do
          scope = Price.by_package_and_price_type(package_one.id, 'credit_card')
          expect(scope).to eq(price_one)
        end
      end

      context 'without a matching filter' do
        it 'should return nil' do
          scope = Price.by_package_and_price_type(package_two.id, 'bank_slip')
          expect(scope).to eq(nil)
        end
      end
    end

    context 'active_ordered_by_id' do
      let!(:inactive_price) { create(:price, active: false) }

      it 'returns only active prices ordered by id' do
        expect(Price.active_ordered_by_id)
          .to match([price_one, price_two, price_three])
        expect(Price.active_ordered_by_id).not_to include(inactive_price)
      end
    end
  end
end
