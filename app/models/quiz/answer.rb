# frozen_string_literal: true

class Quiz::Answer < ActiveRecord::Base
  include Quiz::Validations::StudyPlanAnswers

  belongs_to :question, class_name: 'Quiz::Question',
                        foreign_key: 'quiz_question_id'
  belongs_to :alternative, class_name: 'Quiz::Alternative',
                           foreign_key: 'quiz_alternative_id'
  belongs_to :form_submission, class_name: 'Quiz::FormSubmission',
                               foreign_key: 'quiz_form_submission_id'

  validates_presence_of :question

  scope :by_form_submission_and_question_id, lambda { |sub_id, question_id|
    where(quiz_form_submission_id: sub_id, quiz_question_id: question_id)
  }

  def self.exam_name_for(form_submission)
    last_answer = by_form_submission_and_question_id(form_submission, 5).last
    return '' unless last_answer

    last_answer.value.split('|').first.upcase
  end
end
