# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Quiz::Answer, type: :model do
  include_context 'study plan form'
  context 'validations' do
    should_belong_to(:question, :alternative, :form_submission)
    should_be_present(:question)
    context 'questions' do
      subject do |current_test|
        FactoryBot.build(current_test.metadata[:factory],
                         form_submission: form_submission)
      end
      context 'questions with alternatives' do
        context 'question 1', factory: :study_plan_quiz_answer_1 do
          let(:question) { question1 }
          let(:valid_value) { '0|morning' }
          let(:invalid_anternative) do
            create(:study_plan_quiz_alternative, question: question)
          end
          it_behaves_like 'a question answer with alternative',
                          "Dia/turno inválidos."
        end
        context 'question 3', factory: :study_plan_quiz_answer_3 do
          let(:question) { question3 }
          let(:valid_value) { '1.2' }
          let(:invalid_anternative) do
            create(:study_plan_quiz_alternative,
                   question: question1)
          end
          it_behaves_like 'a question answer with alternative',
                          "Perfil de estudo inválido."
        end
      end
      context 'question 2', factory: :study_plan_quiz_answer_2 do
        context 'invalid value' do
          context 'value is not an integer', value: 'aa' do
            it_behaves_like 'a invalid quiz answer value', "Matéria inválida."
          end
          context 'value is id but node does not exist', value: '9999' do
            it_behaves_like 'a invalid quiz answer value', "Matéria inválida."
          end
        end
        context 'valid value' do
          before do
            subject.value = create(:node).id
          end
          it_behaves_like 'a valid subject'
        end
      end
      context 'question 4', factory: :study_plan_quiz_answer_4 do
        it_behaves_like 'a valid date answer'
      end
      context 'question 5', factory: :study_plan_quiz_answer_5 do
        it_behaves_like 'a valid date answer'
      end
    end
  end
end
