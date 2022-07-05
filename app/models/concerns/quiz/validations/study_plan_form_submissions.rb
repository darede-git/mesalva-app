# frozen_string_literal: true

module Quiz::Validations::StudyPlanFormSubmissions
  extend ActiveSupport::Concern

  included do
    validate :study_plan_questions_presence, if: :study_plan_form?
  end

  private

  def study_plan_form?
    form.try(:id) == 1
  end

  def study_plan_questions_presence
    return if form_submission_contains_all_required_questions?

    errors.add(:study_plan_answers, I18n.t('errors.messages.missing_answers'))
  end

  def form_submission_question_ids
    answers.map(&:quiz_question_id).sort.uniq
  end

  def form_submission_contains_all_required_questions?
    (quiz_form_study_plan_ids & form_submission_question_ids) == \
      quiz_form_study_plan_ids
  end

  def quiz_form_study_plan_ids
    JSON.parse(ENV['QUIZ_FORM_STUDY_PLAN_IDS'])
  end
end
