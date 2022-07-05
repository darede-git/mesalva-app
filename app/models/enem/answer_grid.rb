# frozen_string_literal: true

class Enem::AnswerGrid < ActiveRecord::Base
  validates :exam, :color, :user, :year, :form_submission, presence: true

  belongs_to :user
  belongs_to :form_submission, class_name: 'Quiz::FormSubmission',
                               foreign_key: 'quiz_form_submission_id'

  has_many :answers, class_name: 'Enem::Answer',
                     foreign_key: 'enem_answer_grid_id'

  scope :distinct_on_exam_by_user_and_year, lambda { |user_id, year|
    select('DISTINCT on (exam) *')
      .where(user_id: user_id)
      .where(year: year)
      .order('exam, created_at DESC')
  }
end
