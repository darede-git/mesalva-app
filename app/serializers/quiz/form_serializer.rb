# frozen_string_literal: true

class Quiz::FormSerializer < ActiveModel::Serializer
  has_many :questions, include_nested_associations: true

  attributes :name, :description, :active, :form_type
end
