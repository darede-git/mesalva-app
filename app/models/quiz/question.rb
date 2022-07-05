# frozen_string_literal: true

class Quiz::Question < ActiveRecord::Base
  belongs_to :form, class_name: 'Quiz::Form', foreign_key: 'quiz_form_id'
  validates :statement, :form, presence: true
  has_many :alternatives, -> { where(active: true).order(id: :asc) },
           class_name: 'Quiz::Alternative',
           foreign_key: 'quiz_question_id'
  validates_inclusion_of :question_type,
                         in: %w[checkbox radio text checkbox_table select]
end
