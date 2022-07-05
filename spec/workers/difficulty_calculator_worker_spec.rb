# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DifficultyCalculatorWorker do
  describe '#perform' do
    before(:all) do
      @easiest_exercise = create(:medium_fixation_exercise, id: 1)
      @easy_exercise = create(:medium_fixation_exercise, id: 2)
      @medium_exercise = create(:medium_fixation_exercise, id: 3)
      @hard_exercise = create(:medium_fixation_exercise, id: 4)
      @hardest_exercise = create(:medium_fixation_exercise, id: 5)

      create(:permalink_event_answer, permalink_medium_id: 1)

      create_list(:permalink_event_answer, 6, permalink_medium_id: 2)
      create(:permalink_event_answer,
             permalink_medium_id: 2,
             permalink_answer_correct: false)

      create_list(:permalink_event_answer, 2, permalink_medium_id: 3)
      create(:permalink_event_answer,
             permalink_medium_id: 3,
             permalink_answer_correct: false)

      create(:permalink_event_answer, permalink_medium_id: 4)
      create(:permalink_event_answer,
             permalink_medium_id: 4,
             permalink_answer_correct: false)

      create(:permalink_event_answer,
             permalink_medium_id: 5,
             permalink_answer_correct: false)

      ENV['MINIMUM_ANSWERS_DIFFICULTY_CALCULATOR'] = 0.to_s
      DifficultyCalculatorWorker.new.perform
    end

    context 'valid params' do
      it 'classifies the exercises from easiest to hardest' do
        expect(@easiest_exercise.reload.difficulty).to eq(1)
        expect(@easy_exercise.reload.difficulty).to eq(2)
        expect(@medium_exercise.reload.difficulty).to eq(3)
        expect(@hard_exercise.reload.difficulty).to eq(4)
        expect(@hardest_exercise.reload.difficulty).to eq(5)
      end
    end
  end
end
