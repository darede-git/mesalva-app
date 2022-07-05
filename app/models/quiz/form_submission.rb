# frozen_string_literal: true

class Quiz::FormSubmission < ActiveRecord::Base
  include Quiz::Validations::StudyPlanFormSubmissions

  belongs_to :form, class_name: 'Quiz::Form', foreign_key: 'quiz_form_id'
  belongs_to :user
  validates_presence_of :form, :user, :answers
  has_many :answers, class_name: 'Quiz::Answer',
                     foreign_key: 'quiz_form_submission_id'

  validates_associated :answers

  accepts_nested_attributes_for :answers

  scope :by_form_and_user, lambda { |form_id, user_id|
    where(quiz_form_id: form_id, user_id: user_id)
  }
end
