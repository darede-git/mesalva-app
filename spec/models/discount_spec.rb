# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Discount, type: :model do
  context 'validations' do
    should_be_present(:packages, :percentual, :name, :code, :starts_at,
                      :expires_at)
    should_have_many(:orders)
    should_belong_to(:user)
    should_validate_uniqueness_of(:token, :code)
    it { should validate_numericality_of(:percentual).is_greater_than(0) }
    it do
      should validate_numericality_of(:percentual).is_less_than_or_equal_to(100)
    end

    it 'upsell_packages should be either nil or not empty array' do
      expect { create(:discount, upsell_packages: []) }
        .to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  let(:discount_20) { create(:discount) }
  let(:discount_attributes) { FactoryBot.attributes_for(:discount) }
  context '.percent' do
    it 'returns discount percentage' do
      expect(discount_20.percent).to eq(0.2)
    end
  end

  context 'save' do
    context 'on create' do
      it 'should upcase the code' do
        expect(Discount.create(discount_attributes).code).to eq('DESCONTO20')
      end
    end

    context 'on update' do
      it 'should upcase the code' do
        discount_20.update_attributes(code: 'novodesconto20')
        expect(discount_20.reload.code).to eq('NOVODESCONTO20')
      end
    end
  end

  context '.deduct_discount' do
    context 'when input a value' do
      it 'returns value * discount percent' do
        expect(discount_20.deduct_discount(10.00)).to eq(2.00)
      end

      context 'calculated value precision is > 2' do
        context 'when value to be rounded is >= 5' do
          it 'rounds up the value' do
            expect(discount_20.deduct_discount(11.125)).to eq(2.23)
            expect(discount_20.deduct_discount(11.14)).to eq(2.23)
          end
        end

        context 'when value to be rounded is < 5' do
          it 'rounds down the value' do
            expect(discount_20.deduct_discount(11.11)).to eq(2.22)
          end
        end
      end
    end
  end
end
