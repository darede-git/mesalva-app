# frozen_string_literal: false

require 'rails_helper'

RSpec.shared_examples 'an random percentage generator' \
  do |random_number, percentual|
  random_number.each do |random|
    context "with random value is #{random}" do
      before { allow(Random).to receive(:rand).with(1..100).and_return(random) }
      it "returns discount percentual #{percentual}" do
        expect(subject.build.percentual).to eq(percentual)
      end
    end
  end
end

describe MeSalva::Campaign::Carnaval::DiscountGenerator do
  subject { described_class.new(user.id) }

  describe '#build' do
    it_behaves_like 'an random percentage generator', [1, 15, 30], 20
    it_behaves_like 'an random percentage generator', [31, 55, 70], 30
    it_behaves_like 'an random percentage generator', [71, 75, 80], 40
    it_behaves_like 'an random percentage generator', [81, 85, 90], 50
    it_behaves_like 'an random percentage generator', [91, 94, 96], 60
    it_behaves_like 'an random percentage generator', [97, 98, 99], 70
    it_behaves_like 'an random percentage generator', [100], 80

    context 'without an existing campaign discount' do
      before do
        allow(SecureRandom).to receive(:urlsafe_base64)
          .and_return('nAL5oN-4w3Pcg0P7HDN7AC')
      end

      it 'returns a new campaign discount' do
        expect do
          new_discount = subject.build
          discount = Discount.last

          expect(new_discount).to eq(discount)
          expect(new_discount.code).to eq('SURPRESANAL5ON-4')
        end.to change(Discount, :count).by(1)
      end
    end

    context 'with an existing campaign discount' do
      it 'returns the last discount created by user' do
        discount = create(:discount,
                          user_id: user.id,
                          name: 'Carnaval2018')

        expect do
          expect(subject.build).to eq(discount)
        end.to change(Discount, :count).by(0)
      end
    end
  end
end
