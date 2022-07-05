# frozen_string_literal: true

class EntityAnswerSerializer < ActiveModel::Serializer
  attributes :id, :text, :explanation, :correct, :active
end
