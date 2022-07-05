# frozen_string_literal: true

class Quiz::Alternative < ActiveRecord::Base
  belongs_to :question, class_name: 'Quiz::Question',
                        foreign_key: 'quiz_question_id'
  validates :description, :question, :value, presence: true

  scope :by_question_id, ->(id) { where(quiz_question_id: id) }
end
