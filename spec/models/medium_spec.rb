# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Medium, type: :model do
  include SlugAssertionHelper
  include ContentStructureCreationHelper

  context 'validations' do
    should_be_present(:name, :medium_type)
    should_have_many(:nodes, :node_modules, :items)
    it do
      should validate_inclusion_of(:medium_type)
        .in_array(%w[
                    text
                    comprehension_exercise
                    fixation_exercise
                    video
                    pdf
                    essay
                    public_document
                    typeform
                    soundcloud
                    essay_video
                    correction_video
                  ])
    end
    it { should validate_uniqueness_of(:slug) }
    it { should allow_value("", nil).for(:difficulty) }
    it { should validate_numericality_of(:difficulty).is_greater_than(0) }
    it do
      should validate_numericality_of(:difficulty).is_less_than_or_equal_to(5)
    end

    context 'medium type is video' do
      before { allow(subject).to receive(:video?).and_return(true) }
      should_be_present(:seconds_duration)
    end

    context 'medium type is not video' do
      before { allow(subject).to receive(:video?).and_return(false) }
      it { should_not validate_presence_of(:seconds_duration) }
    end

    context 'medium type is exercise' do
      status = %w[reviewed revision_pending adjusts_pending]
      before { allow(subject).to receive(:exercise?).and_return(true) }
      should_be_present(:audit_status)
      it { should validate_inclusion_of(:audit_status).in_array(status) }
      context 'validates exercise size' do
        it 'does not allow saving a too big exercise' do
          medium = exercise_with_long_text(8501)
          expect { medium.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end
        it 'allows saving an exercise with valid size' do
          medium = exercise_with_long_text(5000)
          expect do
            medium.save
          end.to change(Medium, :count).by(1)
        end
      end
    end

    it do
      should_not allow_value('exercise').for(:medium_type)
      should_not allow_value('module').for(:medium_type)
      should_not allow_value('node').for(:medium_type)
    end
  end

  context 'scopes' do
    context '.active' do
      it 'returns only the active nodes' do
        assert_valid('medium')
      end
    end
  end

  context 'hooks' do
    it 'on save should create slug' do
      create_and_assert_slug('medium', 'name')
    end
  end
end
