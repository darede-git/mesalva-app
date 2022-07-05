# frozen_string_literal: true

require 'rails_helper'

specs = {
  index: %w[category comment correction_style education_level
            essay_submission objective order package quiz/alternative
            quiz/form quiz/form_submission quiz/question
            answer_grid sisu/institute sisu/counter
            scholar_record],
  show: %w[category essay_submission order quiz/alternative
           quiz/form quiz/form_submission quiz/question],
  create: %w[cancellation_quiz checkout comment crm_event discount
             essay_submission package quiz/alternative sisu/user_scores
             quiz/form quiz/form_submission quiz/question
             scholar_record sisu_satisfaction
             credit_cards],
  update: %w[comment discount education_level essay_submission
             item media node node_module objective quiz/alternative
             quiz/form quiz/question user/study_plan_node_module
             user/study_plans],
  destroy: %w[education_level item media node node_module objective
              quiz/alternative quiz/form quiz/question]
}

specs.each do |spec, controllers|
  controllers.each do |controller|
    describe "#{controller.classify.pluralize}Controller".constantize,
             type: :routing do
      describe 'when routing' do
        context "to ##{spec}" do
          it_should_behave_like "a generic #{spec} route", controller
        end
      end
    end
  end
end
