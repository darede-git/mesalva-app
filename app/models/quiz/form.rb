# frozen_string_literal: true

class Quiz::Form < ActiveRecord::Base
  has_many :questions, -> { order(:position, :id) },
           class_name: 'Quiz::Question',
           foreign_key: 'quiz_form_id'
  validates :name, :form_type, :description, presence: true, allow_blank: false
  validates_inclusion_of :form_type, in: %w[study_plan answer_grid standard]
  has_many :form_submissions, class_name: 'Quiz::FormSubmission',
                              foreign_key: 'quiz_form_id'
end
