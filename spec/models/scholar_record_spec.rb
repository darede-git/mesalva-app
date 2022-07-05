# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScholarRecord, type: :model do
  context 'validations' do
    context 'validate only college or school is present' do
      context 'when both is null' do
        let(:scholar_record) { build(:scholar_record) }

        it 'returns invalid' do
          expect(scholar_record).to be_invalid
        end
      end

      context 'when both are present' do
        let(:scholar_record) do
          build(:scholar_record,
                college: create(:college),
                school: create(:school))
        end
        it 'returns invalid' do
          expect(scholar_record).to be_invalid
        end
      end

      context 'with college' do
        let(:scholar_record) { build(:scholar_record, :with_college) }
        it 'returns valid' do
          expect(scholar_record).to be_valid
        end
      end

      context 'with school' do
        let(:scholar_record) { build(:scholar_record, :with_school) }
        it 'returns valid' do
          expect(scholar_record).to be_valid
        end
      end
    end

    context 'college is present' do
      before do
        allow(subject).to receive(:college).and_return(create(:college))
      end
      should_be_present(:major)
    end
  end

  context 'scopes' do
    let!(:active) do
      create(:scholar_record, :with_school, user: user)
    end
    let!(:inactive) do
      create(:scholar_record, :with_school, :inactive, user: user)
    end

    context '.active' do
      it 'returns only the active scholar records' do
        expect(ScholarRecord.active).to eq([active])
      end
    end

    context '.by_user' do
      before { create(:scholar_record, :with_school) }

      it 'returns only the active scholar records by user' do
        expect(ScholarRecord.by_user(user)).to eq([active])
      end
    end
  end
end
