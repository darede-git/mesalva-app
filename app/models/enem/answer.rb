# frozen_string_literal: true

class Enem::Answer < ActiveRecord::Base
  validates :question, :value, :correct_value, :alternative, presence: true

  belongs_to :form_submission, class_name: 'Quiz::FormSubmission',
                               foreign_key: 'quiz_form_submission_id'

  belongs_to :answer_grid, class_name: 'Enem::AnswerGrid',
                           foreign_key: 'enem_answer_grid_id'

  belongs_to :alternative, class_name: 'Quiz::Alternative',
                           foreign_key: 'quiz_alternative_id'

  belongs_to :question, class_name: 'Quiz::Question',
                        foreign_key: 'quiz_question_id'
end
