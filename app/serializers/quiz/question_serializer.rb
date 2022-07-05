# frozen_string_literal: true

class Quiz::QuestionSerializer < ActiveModel::Serializer
  has_many :alternatives

  attributes :statement, :question_type, :description, :required
  has_one :form
end
