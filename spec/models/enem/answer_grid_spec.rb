# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Enem::AnswerGrid, type: :model do
  context 'validations' do
    should_be_present(:exam, :color, :user, :year, :form_submission)
  end

  context 'scopes' do
    let(:form_submission) do
      create(:answer_grid_quiz_form_submission_with_answers)
    end

    context '.distinct_on_exam_by_user' do
      let!(:user2) { create(:user) }
      let!(:answer_grid) do
        create(:enem_answer_grid, user: user, created_at: Time.now,
                                  form_submission: form_submission)
      end
      let!(:answer_grid2) do
        create(:enem_answer_grid, user: user,
                                  created_at: Time.now - 1.hour,
                                  form_submission: form_submission)
      end
      let!(:answer_grid3) do
        create(:enem_answer_grid, user: user2,
                                  form_submission: form_submission)
      end
      let!(:answer_grid4) do
        create(:enem_answer_grid, :exam_mat,
               user: user, form_submission: form_submission)
      end

      it 'returns answer grids disctint on exam by user' do
        expect(Enem::AnswerGrid
               .distinct_on_exam_by_user_and_year(user.id, 2018))
          .to eq([answer_grid, answer_grid4])
      end
    end
  end
end
