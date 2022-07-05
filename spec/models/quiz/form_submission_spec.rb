# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Quiz::FormSubmission, type: :model do
  include_context 'study plan form'

  RSpec.shared_examples 'an invalid form submission' do
    it 'invalidates the form submission' do
      expect do
        expect(subject.save).to be_falsey
        expect(subject.id).to be_nil
      end.to change(Quiz::FormSubmission, :count).by(0)
    end
  end

  RSpec.shared_examples 'a form submissions with missing answers' do
    it_behaves_like 'an invalid form submission'
    it 'returns an error message' do
      subject.save
      expect(subject.errors.messages).to \
        eq(study_plan_answers: ["Preencha todas as respostas."])
    end
  end

  describe 'validations' do
    should_belong_to(:form, :user)
    should_have_many(:answers)
    should_be_present(:form, :user, :answers)
    it { should accept_nested_attributes_for :answers }

    context 'quiz form is study plan' do
      before do
        ActiveRecord::Base.connection.reset_pk_sequence!('quiz_questions')
        subject.user = user
        subject.form = form
      end

      context 'empty answers' do
        it_behaves_like 'an invalid form submission'
      end

      context 'invalid answers' do
        let(:quiz_question) do
          create(:quiz_question, form: form)
        end
        let(:quiz_alternative) do
          create(:quiz_alternative, question: quiz_question)
        end

        before do
          answer_attributes = { quiz_question_id: quiz_alternative.question.id,
                                quiz_alternative_id: quiz_alternative.id }
          subject.answers_attributes = [answer_attributes]
        end

        it_behaves_like 'a form submissions with missing answers'
      end

      context 'valid but incomplete answers' do
        let(:quiz_alternative) do
          create(:quiz_alternative,
                 question: question1,
                 value: '0|evening')
        end

        before do
          answer_attributes = { quiz_question_id: quiz_alternative.question.id,
                                quiz_alternative_id: quiz_alternative.id }
          subject.answers_attributes = [answer_attributes]
        end

        it_behaves_like 'a form submissions with missing answers'
      end

      context 'containing all valid answers' do
        let(:node_subject) { create(:node_subject) }
        before do
          answer_attributes = [
            { quiz_question_id: 1,
              quiz_alternative_id: first_alternative_id(question1) },
            { quiz_question_id: 2, value: node_subject.id },
            { quiz_question_id: 3,
              quiz_alternative_id: first_alternative_id(question3) },
            { quiz_question_id: 4, value: Time.now.to_date.to_s },
            { quiz_question_id: 5, value: (Time.now + 2.months).to_date.to_s }
          ]
          subject.answers_attributes = answer_attributes
        end

        it 'validates the form submission' do
          expect do
            expect(subject.save).to be_truthy
          end.to \
            change(Quiz::FormSubmission, :count)
            .by(1).and \
              change(Quiz::Answer, :count)
            .by(5)
        end
      end
    end
  end

  def first_alternative_id(question)
    question.alternatives.first.id
  end
end
