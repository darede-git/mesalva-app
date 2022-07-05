# frozen_string_literal: true

class Quiz::AlternativeSerializer < ActiveModel::Serializer
  attributes :description, :value
end
