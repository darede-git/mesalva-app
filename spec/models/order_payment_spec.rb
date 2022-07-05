# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrderPayment, type: :model do
  describe 'validations' do
    methods = OrderPayment::Methods::ALL

    it { should validate_inclusion_of(:payment_method).in_array(methods) }
    it { should validate_numericality_of(:installments) }

    describe 'installments' do
      context 'when bank slip' do
        before { subject.payment_method = OrderPayment::Methods::BANK_SLIP }

        context 'zero installments' do
          before { subject.installments = 0 }
          it { should_not be_valid }
        end

        context 'one installment' do
          before { subject.installments = 1 }
          it { should be_valid }
        end

        context 'two installments' do
          before { subject.installments = 2 }
          it { should_not be_valid }
        end
      end

      context 'when card' do
        before { subject.payment_method = OrderPayment::Methods::CARD }

        context 'zeros installments' do
          before { subject.installments = 0 }
          it { should_not be_valid }
        end

        context 'one installment' do
          before { subject.installments = 1 }
          it { should be_valid }
        end

        context 'two installments' do
          before { subject.installments = 2 }
          it { should be_valid }
        end
      end
    end
  end

  describe '#card?' do
    context 'when card' do
      subject { build(:payment) }

      it 'returns true' do
        expect(subject).to be_card
      end
    end

    context 'when NOT card' do
      subject { build(:payment, :bank_slip) }

      it 'returns false' do
        expect(subject).to_not be_card
      end
    end
  end

  describe '#bank_slip?' do
    context 'when bank slip' do
      subject { build(:payment, payment_method: 'bank_slip') }

      it 'returns true' do
        expect(subject).to be_bank_slip
      end
    end

    context 'when NOT bank_slip' do
      subject { build(:payment, payment_method: 'card') }

      it 'returns false' do
        expect(subject).to_not be_bank_slip
      end
    end
  end
end
