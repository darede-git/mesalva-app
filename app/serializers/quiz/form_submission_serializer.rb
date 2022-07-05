# frozen_string_literal: true

class Quiz::FormSubmissionSerializer < ActiveModel::Serializer
  has_many :answers
  has_one :form
  has_one :user
end
