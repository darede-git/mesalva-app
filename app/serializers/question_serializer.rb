# frozen_string_literal: true

class QuestionSerializer < ActiveModel::Serializer
  include SerializationHelper

  attributes :id, :title, :image, :answer,
             :created_by, :updated_by

  def id
    object.token
  end
end
