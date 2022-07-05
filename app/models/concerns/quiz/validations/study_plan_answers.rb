# frozen_string_literal: true

module Quiz::Validations::StudyPlanAnswers
  extend ActiveSupport::Concern

  included do
    validate :study_plan_answer_format, if: :study_plan_question?
  end

  private

  QUESTION_1_VALUES = ["0|morning", "0|mid",     "0|evening", "1|morning",
                       "1|mid",     "1|evening", "2|morning", "2|mid",
                       "2|evening", "3|morning", "3|mid",     "3|evening",
                       "4|morning", "4|mid",     "4|evening", "5|morning",
                       "5|mid",     "5|evening", "6|morning", "6|mid",
                       "6|evening"].freeze

  def study_plan_question?
    JSON.parse(ENV['QUIZ_FORM_STUDY_PLAN_IDS']).include?(quiz_question_id)
  end

  def study_plan_answer_format
    send("valid_answer_for_question_#{quiz_question_id}?")
  end

  def valid_answer_for_question_1?
    return if valid_alternative_value?(QUESTION_1_VALUES, alternative)

    errors.add(:answer, I18n.t('errors.messages.invalid_day_shift'))
  end

  def valid_answer_for_question_2?
    return if value =~ /^[1-9][0-9]*$/ && Node.exists?(value)

    errors.add(:answer, I18n.t('errors.messages.invalid_subject'))
  end

  def valid_answer_for_question_3?
    return if alternative.present? && valid_alternative_id?

    errors.add(:answer, I18n.t('errors.messages.invalid_study_style'))
  end

  def valid_answer_for_question_4?
    validate_study_plan_date
  end

  def valid_answer_for_question_5?
    validate_study_plan_date
  end

  def validate_study_plan_date
    parsed_date = Date.strptime(value.split('|').last, '%Y-%m-%d')
    add_invalid_date_error if parsed_date.past?
  rescue ArgumentError
    add_invalid_date_error
  end

  def add_invalid_date_error
    errors.add(:answer, I18n.t('errors.messages.invalid_date'))
  end

  def valid_alternative_value?(valid_values, alternative)
    alternative.present? && valid_values.include?(alternative.value)
  end

  def valid_alternative_id?
    alternative_ids_by_question(3).include?(alternative.id)
  end

  def alternative_ids_by_question(question_id)
    Quiz::Alternative.where(quiz_question_id: question_id).pluck(:id)
  end
end
