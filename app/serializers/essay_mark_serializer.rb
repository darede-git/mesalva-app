# frozen_string_literal: true

class EssayMarkSerializer < ActiveModel::Serializer
  attributes :id, :description, :mark_type, :coordinate

  belongs_to :essay_submission
end
